import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var overlayPanel: RecordingPanel?
  private var overlayChannel: FlutterMethodChannel?
  
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    guard let controller = mainFlutterWindow?.contentViewController as? FlutterViewController else { return }
    
    overlayChannel = FlutterMethodChannel(
      name: "recording_overlay",
      binaryMessenger: controller.engine.binaryMessenger
    )
    
    overlayChannel?.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "show":
        self?.showOverlay()
        result(nil)
      case "hide":
        self?.hideOverlay()
        result(nil)
      case "updateState":
        if let args = call.arguments as? [String: Any] {
          self?.updateOverlayState(args)
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func showOverlay() {
    if overlayPanel == nil {
      overlayPanel = RecordingPanel(channel: overlayChannel!)
    }
    overlayPanel?.orderFront(nil)
  }
  
  private func hideOverlay() {
    overlayPanel?.orderOut(nil)
  }
  
  private func updateOverlayState(_ args: [String: Any]) {
    overlayPanel?.updateState(args)
  }
}

class RecordingPanel: NSPanel, NSWindowDelegate {
  private let channel: FlutterMethodChannel
  private var statusLabel: NSTextField!
  private var timeLabel: NSTextField!
  private var pauseButton: NSButton!
  private var stopButton: NSButton!
  private var minimizeButton: NSButton!
  private var waveformView: WaveformView!
  private var isMinimized = false
  private var normalFrame: NSRect!
  
  // Action handlers
  private var onPauseResume: (() -> Void)?
  private var onStop: (() -> Void)?
  private var onMinimize: (() -> Void)?
  
  init(channel: FlutterMethodChannel) {
    self.channel = channel
    let frame = NSRect(x: 0, y: 0, width: 320, height: 180)
    normalFrame = frame
    
    super.init(
      contentRect: frame,
      styleMask: [.titled, .fullSizeContentView, .closable, .miniaturizable],
      backing: .buffered,
      defer: false
    )
    
    self.isFloatingPanel = true
    self.level = .floating
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]
    self.backgroundColor = NSColor(white: 0.1, alpha: 0.95)
    self.isOpaque = false
    self.hasShadow = true
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.isMovableByWindowBackground = true
    self.standardWindowButton(.closeButton)?.isHidden = true
    self.standardWindowButton(.miniaturizeButton)?.isHidden = true
    self.standardWindowButton(.zoomButton)?.isHidden = true
    self.isReleasedWhenClosed = false
    
    // Handle window close button
    self.delegate = self
    
    // Setup action handlers
    onPauseResume = { [weak self] in
      self?.channel.invokeMethod("pauseOrResume", arguments: nil)
    }
    onStop = { [weak self] in
      self?.channel.invokeMethod("stop", arguments: nil)
    }
    onMinimize = { [weak self] in
      self?.toggleMinimize()
    }
    
    setupUI()
    centerOnScreen()
  }
  
  private func centerOnScreen() {
    guard let screen = NSScreen.main else { return }
    let screenFrame = screen.visibleFrame
    setFrameOrigin(NSPoint(
      x: screenFrame.maxX - screenFrame.width - 24,
      y: screenFrame.minY + 24
    ))
  }
  
  private func setupUI() {
    let panelRect = self.frame
    let contentView = NSView(frame: panelRect)
    contentView.wantsLayer = true
    contentView.layer?.cornerRadius = 16
    contentView.layer?.backgroundColor = NSColor(
      red: 0.1, green: 0.11, blue: 0.14, alpha: 0.95
    ).cgColor
    
    // Status dot
    let statusDot = NSView(frame: NSRect(x: 16, y: 16, width: 10, height: 10))
    statusDot.wantsLayer = true
    statusDot.layer?.cornerRadius = 5
    statusDot.layer?.backgroundColor = NSColor.red.cgColor
    statusDot.layer?.shadowColor = NSColor.red.cgColor
    statusDot.layer?.shadowOpacity = 0.5
    statusDot.layer?.shadowRadius = 6
    statusDot.layer?.shadowOffset = CGSize.zero
    contentView.addSubview(statusDot)
    
    // Status label
    statusLabel = NSTextField(labelWithString: "Recording...")
    statusLabel.frame = NSRect(x: 34, y: 12, width: 120, height: 20)
    statusLabel.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
    statusLabel.textColor = .white
    statusLabel.backgroundColor = .clear
    statusLabel.isEditable = false
    statusLabel.isSelectable = false
    statusLabel.drawsBackground = false
    contentView.addSubview(statusLabel)
    
    // Time label
    timeLabel = NSTextField(labelWithString: "00:00")
    timeLabel.frame = NSRect(x: panelRect.width - 90, y: 12, width: 74, height: 20)
    timeLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
    timeLabel.textColor = .white
    timeLabel.alignment = .right
    timeLabel.backgroundColor = .clear
    timeLabel.isEditable = false
    timeLabel.isSelectable = false
    timeLabel.drawsBackground = false
    contentView.addSubview(timeLabel)
    
    // Waveform view
    let waveformFrame = NSRect(x: 16, y: 50, width: panelRect.width - 32, height: 50)
    waveformView = WaveformView(frame: waveformFrame)
    waveformView.wantsLayer = true
    contentView.addSubview(waveformView)
    
    // Buttons
    let buttonY: CGFloat = 110
    let buttonWidth: CGFloat = 80
    let buttonHeight: CGFloat = 36
    let buttonSpacing: CGFloat = 12
    let totalWidth = buttonWidth * 3 + buttonSpacing * 2
    let startX = (panelRect.width - totalWidth) / 2
    
    pauseButton = ActionButton(
      frame: NSRect(x: startX, y: buttonY, width: buttonWidth, height: buttonHeight),
      title: "Pause",
      icon: NSImage(systemSymbolName: "pause.fill", accessibilityDescription: nil),
      action: onPauseResume
    )
    contentView.addSubview(pauseButton)
    
    stopButton = ActionButton(
      frame: NSRect(x: startX + buttonWidth + buttonSpacing, y: buttonY, width: buttonWidth, height: buttonHeight),
      title: "Stop",
      icon: NSImage(systemSymbolName: "stop.fill", accessibilityDescription: nil),
      isDestructive: true,
      action: onStop
    )
    contentView.addSubview(stopButton)
    
    minimizeButton = ActionButton(
      frame: NSRect(x: startX + (buttonWidth + buttonSpacing) * 2, y: buttonY, width: buttonWidth, height: buttonHeight),
      title: "Shrink",
      icon: NSImage(systemSymbolName: "arrow.down.right", accessibilityDescription: nil),
      action: onMinimize
    )
    contentView.addSubview(minimizeButton)
    
    contentView.frame = panelRect
    contentView.autoresizingMask = [.width, .height]
    self.contentView = contentView
  }
  
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    self.orderOut(nil)
    return false
  }
  
  func updateState(_ args: [String: Any]) {
    if let status = args["status"] as? String {
      statusLabel.stringValue = status == "paused" ? "Paused" : "Recording..."
    }
    if let time = args["time"] as? String {
      timeLabel.stringValue = time
    }
    if let level = args["level"] as? Double {
      waveformView.updateLevel(level)
    }
  }
  
  func toggleMinimize() {
    isMinimized.toggle()
    if isMinimized {
      let currentOrigin = frame.origin
      setFrame(NSRect(x: currentOrigin.x, y: currentOrigin.y, width: 180, height: 40), display: true, animate: true)
      statusLabel.isHidden = true
      waveformView.isHidden = true
      pauseButton.isHidden = true
      stopButton.isHidden = true
      minimizeButton.isHidden = true
      timeLabel.frame = NSRect(x: 50, y: 10, width: 120, height: 20)
    } else {
      setFrame(normalFrame, display: true, animate: true)
      statusLabel.isHidden = false
      waveformView.isHidden = false
      pauseButton.isHidden = false
      stopButton.isHidden = false
      minimizeButton.isHidden = false
      timeLabel.frame = NSRect(x: normalFrame.width - 90, y: 12, width: 74, height: 20)
    }
  }
}

// Custom button class that stores action closure
class ActionButton: NSButton {
  private var actionClosure: (() -> Void)?
  
  init(
    frame: NSRect,
    title: String,
    icon: NSImage?,
    isDestructive: Bool = false,
    action: (() -> Void)?
  ) {
    super.init(frame: frame)
    self.actionClosure = action
    
    self.title = title
    self.image = icon
    self.imagePosition = .imageLeft
    self.bezelStyle = .rounded
    self.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
    
    if isDestructive {
      self.layer?.backgroundColor = NSColor.red.withAlphaComponent(0.2).cgColor
      self.contentTintColor = .red
    } else {
      self.layer?.backgroundColor = NSColor(white: 0.2, alpha: 1).cgColor
      self.contentTintColor = .white
    }
    
    self.layer?.cornerRadius = 8
    self.wantsLayer = true
    self.setButtonType(.momentaryPushIn)
    self.target = self
    self.action = #selector(buttonPressed)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func buttonPressed() {
    actionClosure?()
  }
}

class WaveformView: NSView {
  private var level: Double = 0.3
  private var displayLink: CVDisplayLink?
  private var phase: Double = 0
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    wantsLayer = true
    startAnimation()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateLevel(_ newLevel: Double) {
    level = newLevel
  }
  
  private func startAnimation() {
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
    CVDisplayLinkSetOutputCallback(displayLink!, { displayLink, inNow, inOutputTime, flagsIn, flagsOut, displayLinkContext -> CVReturn in
      let view = Unmanaged<WaveformView>.fromOpaque(displayLinkContext!).takeUnretainedValue()
      DispatchQueue.main.async {
        view.phase += 0.05
        view.needsDisplay = true
      }
      return kCVReturnSuccess
    }, Unmanaged.passUnretained(self).toOpaque())
    CVDisplayLinkStart(displayLink!)
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    let context = NSGraphicsContext.current?.cgContext
    context?.setStrokeColor(NSColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0).cgColor)
    context?.setLineWidth(2)
    context?.setLineCap(.round)
    
    let centerY = bounds.height / 2
    let points = 60
    let step = bounds.width / CGFloat(points)
    
    let path = CGMutablePath()
    for i in 0...points {
      let x = CGFloat(i) * step
      let wave = sin(Double(i) * 0.3 + phase * 4) * 0.5 + 0.5
      let amplitude = level * wave
      let y = centerY + CGFloat(sin(Double(i) * 0.5 + phase * 2) * amplitude * bounds.height * 0.4)
      
      if i == 0 {
        path.move(to: CGPoint(x: x, y: y))
      } else {
        path.addLine(to: CGPoint(x: x, y: y))
      }
    }
    
    context?.addPath(path)
    context?.strokePath()
  }
}
