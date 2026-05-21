import AVFoundation
import Cocoa
import CoreMedia
import CoreGraphics
import FlutterMacOS
import ScreenCaptureKit

public class NativeAudioEnginePlugin: NSObject, FlutterPlugin {
  private let engine = AVAudioEngine()
  private var audioFile: AVAudioFile?
  private var systemAudioFile: AVAudioFile?
  private var micChunkFile: AVAudioFile?
  private var systemChunkFile: AVAudioFile?
  private var systemStream: Any?
  private let systemAudioQueue = DispatchQueue(label: "meetlyai.system-audio")
  private var levelSink: FlutterEventSink?
  private var lastLevelSentAt = Date(timeIntervalSince1970: 0)
  private var lastMicLevel = 0.0
  private var lastSystemLevel = 0.0
  private var outputDirectory: URL?
  private var startedAt: Date?
  private var pausedAt: Date?
  private var pausedDuration: TimeInterval = 0
  private var isCapturing = false
  private var isPaused = false
  private var sampleRate = 48_000
  private var channels = 1
  private var chunkIndex = 0

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "native_audio_engine",
      binaryMessenger: registrar.messenger
    )
    let levelChannel = FlutterEventChannel(
      name: "native_audio_engine/levels",
      binaryMessenger: registrar.messenger
    )
    let instance = NativeAudioEnginePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    levelChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "listInputDevices":
      result(listInputDevices())
    case "startCapture":
      startCapture(call.arguments, result: result)
    case "pauseCapture":
      pauseCapture(result: result)
    case "resumeCapture":
      resumeCapture(result: result)
    case "flushTranscriptionChunks":
      flushTranscriptionChunks(result: result)
    case "stopCapture":
      stopCapture(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func listInputDevices() -> [[String: Any]] {
    let deviceName = AVCaptureDevice.default(for: .audio)?.localizedName ?? "Default Microphone"
    return [
      [
        "id": "default-mic",
        "name": deviceName,
        "source": "mic",
        "isDefault": true,
        "channels": 1,
      ]
    ]
  }

  private func startCapture(_ arguments: Any?, result: @escaping FlutterResult) {
    guard let args = arguments as? [String: Any],
          let outputDirectoryPath = args["outputDirectory"] as? String
    else {
      result(
        FlutterError(
          code: "bad_arguments",
          message: "startCapture requires outputDirectory.",
          details: nil
        )
      )
      return
    }

    requestMicrophoneAccess { [weak self] granted in
      guard let self else { return }
      guard granted else {
        result(
          FlutterError(
            code: "microphone_permission_denied",
            message: "Microphone permission was denied.",
            details: nil
          )
        )
        return
      }

      Task {
        do {
          try await self.startEngine(
            outputDirectoryPath: outputDirectoryPath,
            sampleRate: args["sampleRate"] as? Int ?? 48_000,
            channels: args["channels"] as? Int ?? 1,
            captureSystemAudio: args["captureSystemAudio"] as? Bool ?? true
          )
          result(nil)
        } catch {
          result(
            FlutterError(
              code: "start_capture_failed",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      }
    }
  }

  private func requestMicrophoneAccess(_ completion: @escaping (Bool) -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized:
      completion(true)
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .audio, completionHandler: completion)
    default:
      completion(false)
    }
  }

  private func startEngine(
    outputDirectoryPath: String,
    sampleRate requestedSampleRate: Int,
    channels requestedChannels: Int,
    captureSystemAudio: Bool
  ) async throws {
    if isCapturing {
      _ = try await stopEngine()
    }

    let directory = URL(fileURLWithPath: outputDirectoryPath, isDirectory: true)
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true
    )

    outputDirectory = directory
    sampleRate = requestedSampleRate
    channels = max(1, requestedChannels)
    startedAt = Date()
    pausedAt = nil
    pausedDuration = 0
    lastMicLevel = 0
    lastSystemLevel = 0
    lastLevelSentAt = Date(timeIntervalSince1970: 0)
    chunkIndex = 0
    isCapturing = true
    isPaused = false

    let input = engine.inputNode
    let format = input.outputFormat(forBus: 0)
    let fileURL = directory.appendingPathComponent("mic.wav")
    if FileManager.default.fileExists(atPath: fileURL.path) {
      try FileManager.default.removeItem(at: fileURL)
    }

    audioFile = try AVAudioFile(forWriting: fileURL, settings: format.settings)
    micChunkFile = try makeChunkFile(directory: directory, source: "mic", format: format)
    input.removeTap(onBus: 0)
    input.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
      guard let self, self.isCapturing, !self.isPaused else { return }
      do {
        try self.audioFile?.write(from: buffer)
        try self.micChunkFile?.write(from: buffer)
        self.lastMicLevel = self.normalizedLevel(buffer: buffer)
        self.emitLevelIfNeeded()
      } catch {
        NSLog("MeetlyAI audio write failed: \(error.localizedDescription)")
      }
    }

    engine.prepare()
    try engine.start()

    if captureSystemAudio {
      try await startSystemAudioCapture(directory: directory)
    }
  }

  private func startSystemAudioCapture(directory: URL) async throws {
    guard #available(macOS 13.0, *) else {
      throw NSError(
        domain: "MeetlyAI",
        code: 1300,
        userInfo: [
          NSLocalizedDescriptionKey:
            "System audio capture requires macOS 13 or newer."
        ]
      )
    }

    guard requestScreenRecordingAccessIfNeeded() else {
      throw NSError(
        domain: "MeetlyAI",
        code: 1302,
        userInfo: [
          NSLocalizedDescriptionKey:
            "Screen Recording permission is required for desktop audio. Grant it in System Settings > Privacy & Security > Screen & System Audio Recording, then restart MeetlyAI."
        ]
      )
    }

    let systemURL = directory.appendingPathComponent("system.wav")
    if FileManager.default.fileExists(atPath: systemURL.path) {
      try FileManager.default.removeItem(at: systemURL)
    }

    let content = try await SCShareableContent.excludingDesktopWindows(
      false,
      onScreenWindowsOnly: true
    )
    guard let display = content.displays.first else {
      throw NSError(
        domain: "MeetlyAI",
        code: 1301,
        userInfo: [NSLocalizedDescriptionKey: "No display available for system audio capture."]
      )
    }

    let configuration = SCStreamConfiguration()
    configuration.capturesAudio = true
    configuration.excludesCurrentProcessAudio = true
    configuration.sampleRate = sampleRate
    configuration.channelCount = channels
    configuration.width = 2
    configuration.height = 2
    configuration.minimumFrameInterval = CMTime(value: 1, timescale: 1)

    let filter = SCContentFilter(display: display, excludingWindows: [])
    let stream = SCStream(filter: filter, configuration: configuration, delegate: nil)
    try stream.addStreamOutput(self, type: .audio, sampleHandlerQueue: systemAudioQueue)
    systemStream = stream
    try await stream.startCapture()
  }

  private func requestScreenRecordingAccessIfNeeded() -> Bool {
    if CGPreflightScreenCaptureAccess() {
      return true
    }
    return CGRequestScreenCaptureAccess()
  }

  private func pauseCapture(result: @escaping FlutterResult) {
    guard isCapturing else {
      result(nil)
      return
    }
    pausedAt = Date()
    isPaused = true
    engine.pause()
    result(nil)
  }

  private func resumeCapture(result: @escaping FlutterResult) {
    guard isCapturing else {
      result(nil)
      return
    }
    if let pausedAt {
      pausedDuration += Date().timeIntervalSince(pausedAt)
    }
    self.pausedAt = nil
    isPaused = false
    do {
      try engine.start()
      result(nil)
    } catch {
      result(
        FlutterError(
          code: "resume_capture_failed",
          message: error.localizedDescription,
          details: nil
        )
      )
    }
  }

  private func stopCapture(result: @escaping FlutterResult) {
    Task {
      do {
        let assets = try await stopEngine()
        result(assets)
      } catch {
        result(
          FlutterError(
            code: "stop_capture_failed",
            message: error.localizedDescription,
            details: nil
          )
        )
      }
    }
  }

  private func flushTranscriptionChunks(result: @escaping FlutterResult) {
    do {
      let assets = try rotateTranscriptionChunks(continueCapturing: isCapturing && !isPaused)
      result(assets)
    } catch {
      result(
        FlutterError(
          code: "flush_chunks_failed",
          message: error.localizedDescription,
          details: nil
        )
      )
    }
  }

  private func stopEngine() async throws -> [[String: Any]] {
    guard let directory = outputDirectory else {
      return []
    }

    _ = try rotateTranscriptionChunks(continueCapturing: false)

    if isCapturing {
      engine.inputNode.removeTap(onBus: 0)
      engine.stop()
    }

    audioFile = nil
    micChunkFile = nil
    if #available(macOS 13.0, *), let stream = systemStream as? SCStream {
      try await stream.stopCapture()
    }
    systemStream = nil
    systemAudioFile = nil
    systemChunkFile = nil
    isCapturing = false
    isPaused = false

    let micURL = directory.appendingPathComponent("mic.wav")
    let systemURL = directory.appendingPathComponent("system.wav")
    let mixedURL = directory.appendingPathComponent("mixed.wav")
    if FileManager.default.fileExists(atPath: mixedURL.path) {
      try FileManager.default.removeItem(at: mixedURL)
    }
    if FileManager.default.fileExists(atPath: micURL.path) {
      try FileManager.default.copyItem(at: micURL, to: mixedURL)
    }

    let durationMs = elapsedMilliseconds()
    var assets: [[String: Any]] = []
    if FileManager.default.fileExists(atPath: micURL.path) {
      assets.append(asset(source: "mic", url: micURL, durationMs: durationMs))
    }
    if FileManager.default.fileExists(atPath: systemURL.path) {
      assets.append(asset(source: "system", url: systemURL, durationMs: durationMs))
    }
    if FileManager.default.fileExists(atPath: mixedURL.path) {
      assets.append(asset(source: "mixed", url: mixedURL, durationMs: durationMs))
    }
    return assets
  }

  private func asset(source: String, url: URL, durationMs: Int) -> [String: Any] {
    let attributes = (try? FileManager.default.attributesOfItem(atPath: url.path)) ?? [:]
    let byteSize = attributes[.size] as? Int ?? 0
    return [
      "source": source,
      "path": url.path,
      "sampleRate": sampleRate,
      "channels": channels,
      "durationMs": durationMs,
      "byteSize": byteSize,
    ]
  }

  private func elapsedMilliseconds() -> Int {
    guard let startedAt else { return 0 }
    let end = pausedAt ?? Date()
    return max(0, Int((end.timeIntervalSince(startedAt) - pausedDuration) * 1000))
  }

  private func chunkDirectory(_ directory: URL) throws -> URL {
    let url = directory.appendingPathComponent("transcription_chunks", isDirectory: true)
    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    return url
  }

  private func makeChunkFile(
    directory: URL,
    source: String,
    format: AVAudioFormat
  ) throws -> AVAudioFile {
    let chunks = try chunkDirectory(directory)
    let fileName = "\(source)_\(String(format: "%06d", chunkIndex)).wav"
    let url = chunks.appendingPathComponent(fileName)
    if FileManager.default.fileExists(atPath: url.path) {
      try FileManager.default.removeItem(at: url)
    }
    return try AVAudioFile(forWriting: url, settings: format.settings)
  }

  private func rotateTranscriptionChunks(continueCapturing: Bool) throws -> [[String: Any]] {
    guard let directory = outputDirectory else { return [] }
    let durationMs = elapsedMilliseconds()
    let chunks = try chunkDirectory(directory)
    
    var assets: [[String: Any]] = []
    let currentIndex = chunkIndex
    
    // Check both mic and system chunks that are currently being written to
    for source in ["mic", "system"] {
      let url = chunks.appendingPathComponent(
        "\(source)_\(String(format: "%06d", currentIndex)).wav"
      )
      if FileManager.default.fileExists(atPath: url.path) {
        let attributes = (try? FileManager.default.attributesOfItem(atPath: url.path)) ?? [:]
        let byteSize = attributes[.size] as? Int ?? 0
        if byteSize > 44 {
          assets.append(asset(source: source, url: url, durationMs: durationMs))
        }
      }
    }
    
    // Close current chunk files before rotating
    micChunkFile = nil
    systemChunkFile = nil
    
    chunkIndex += 1
    
    if continueCapturing {
      if let directory = outputDirectory {
        let inputFormat = engine.inputNode.outputFormat(forBus: 0)
        micChunkFile = try makeChunkFile(
          directory: directory,
          source: "mic",
          format: inputFormat
        )
      }
    }
    return assets
  }
}

@available(macOS 13.0, *)
extension NativeAudioEnginePlugin: SCStreamOutput {
  public func stream(
    _ stream: SCStream,
    didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
    of outputType: SCStreamOutputType
  ) {
    guard outputType == .audio, isCapturing, !isPaused else { return }
    guard let directory = outputDirectory else { return }
    guard let formatDescription = sampleBuffer.formatDescription else { return }

    let format = AVAudioFormat(cmAudioFormatDescription: formatDescription)
    do {
      if systemAudioFile == nil {
        let url = directory.appendingPathComponent("system.wav")
        systemAudioFile = try AVAudioFile(forWriting: url, settings: format.settings)
      }
      if systemChunkFile == nil {
        systemChunkFile = try makeChunkFile(
          directory: directory,
          source: "system",
          format: format
        )
      }

      try sampleBuffer.withAudioBufferList { audioBufferList, _ in
        guard let buffer = AVAudioPCMBuffer(
          pcmFormat: format,
          bufferListNoCopy: audioBufferList.unsafePointer
        ) else {
          return
        }
        try self.systemAudioFile?.write(from: buffer)
        try self.systemChunkFile?.write(from: buffer)
        self.lastSystemLevel = self.normalizedLevel(buffer: buffer)
        self.emitLevelIfNeeded()
      }
    } catch {
      NSLog("MeetlyAI system audio write failed: \(error.localizedDescription)")
    }
  }
}

extension NativeAudioEnginePlugin: FlutterStreamHandler {
  public func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    levelSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    levelSink = nil
    return nil
  }
}

private extension NativeAudioEnginePlugin {
  func normalizedLevel(buffer: AVAudioPCMBuffer) -> Double {
    guard let channelData = buffer.floatChannelData else { return 0 }
    let frameLength = Int(buffer.frameLength)
    guard frameLength > 0 else { return 0 }

    var sum = 0.0
    let channelCount = Int(buffer.format.channelCount)
    for channel in 0..<max(1, channelCount) {
      let samples = channelData[channel]
      for frame in 0..<frameLength {
        let sample = Double(samples[frame])
        sum += sample * sample
      }
    }

    let rms = sqrt(sum / Double(frameLength * max(1, channelCount)))
    let db = 20 * log10(max(rms, 0.000_001))
    return min(1, max(0, (db + 60) / 48))
  }

  func emitLevelIfNeeded() {
    let now = Date()
    guard now.timeIntervalSince(lastLevelSentAt) >= 0.05 else { return }
    lastLevelSentAt = now

    let mic = lastMicLevel
    let system = lastSystemLevel
    let mixed = min(1, sqrt((mic * mic + system * system) / 2.0) * 1.18)
    let timestampMs = elapsedMilliseconds()
    DispatchQueue.main.async { [weak self] in
      self?.levelSink?([
        "micLevel": mic,
        "systemLevel": system,
        "mixedLevel": mixed,
        "timestampMs": timestampMs,
      ])
    }
  }
}
