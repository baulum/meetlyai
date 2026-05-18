import AVFoundation
import Cocoa
import FlutterMacOS

public class NativeAudioEnginePlugin: NSObject, FlutterPlugin {
  private let engine = AVAudioEngine()
  private var audioFile: AVAudioFile?
  private var outputDirectory: URL?
  private var startedAt: Date?
  private var pausedAt: Date?
  private var pausedDuration: TimeInterval = 0
  private var isCapturing = false
  private var isPaused = false
  private var sampleRate = 48_000
  private var channels = 1

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "native_audio_engine",
      binaryMessenger: registrar.messenger
    )
    let instance = NativeAudioEnginePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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

      do {
        try self.startEngine(
          outputDirectoryPath: outputDirectoryPath,
          sampleRate: args["sampleRate"] as? Int ?? 48_000,
          channels: args["channels"] as? Int ?? 1
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
    channels requestedChannels: Int
  ) throws {
    if isCapturing {
      try stopEngine()
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
    isCapturing = true
    isPaused = false

    let input = engine.inputNode
    let format = input.outputFormat(forBus: 0)
    let fileURL = directory.appendingPathComponent("mic.wav")
    if FileManager.default.fileExists(atPath: fileURL.path) {
      try FileManager.default.removeItem(at: fileURL)
    }

    audioFile = try AVAudioFile(forWriting: fileURL, settings: format.settings)
    input.removeTap(onBus: 0)
    input.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
      guard let self, self.isCapturing, !self.isPaused else { return }
      do {
        try self.audioFile?.write(from: buffer)
      } catch {
        NSLog("MeetlyAI audio write failed: \(error.localizedDescription)")
      }
    }

    engine.prepare()
    try engine.start()
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
    do {
      let assets = try stopEngine()
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

  private func stopEngine() throws -> [[String: Any]] {
    guard let directory = outputDirectory else {
      return []
    }

    if isCapturing {
      engine.inputNode.removeTap(onBus: 0)
      engine.stop()
    }

    audioFile = nil
    isCapturing = false
    isPaused = false

    let micURL = directory.appendingPathComponent("mic.wav")
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
}
