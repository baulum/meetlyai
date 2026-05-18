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
    overlayPanel = nil
  }
  
  private func updateOverlayState(_ args: [String: Any]) {
    overlayPanel?.updateState(args)
  }
}

class RecordingPanel: NSPanel {
  private let channel: FlutterMethodChannel
  private var statusLabel: NSTextField!
  private var timeLabel: NSTextField!
  private var pauseButton: NSButton!
  private var stopButton: NSButton!
  private var minimizeButton: NSButton!
  private var waveformView: WaveformView!
  private var isMinimized = false
  private var normalFrame: NSRect!
  
  init(channel: FlutterMethodChannel) {
    self.channel = channel
    let frame = NSRect(x: 0, y: 0, width: 320, height: 180)
    normalFrame = frame
    
    super.init(
      contentRect: frame,
      styleMask: [.nonactivatingPanel, .fullSizeContentView, .hudWindow],
      backing: .buffered,
      defer: false
    )
    
    self.isFloatingPanel = true
    self.level = .floating
    self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    self.backgroundColor = NSColor(white: 0.1, alpha: 0.95)
    self.isOpaque = false
    self.hasShadow = true
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.isMovableByWindowBackground = true
    
    setupUI()
    centerOnScreen()
  }
  
  private func centerOnScreen() {
    guard let screen = NSScreen.main else { return }
    let frame = screen.visibleFrame
    setFrameOrigin(NSPoint(
      x: frame.maxX - frame.width - 24,
      y: frame.minY + 24
    ))
  }
  
  private func setupUI() {
    let contentView = NSView(frame: contentRect)
    contentView.wantsLayer = true
    contentView.layer?.cornerRadius = 16
    contentView.layer?.backgroundColor = NSColor(
      red: 0.1, green: 0.11, blue: 0.14, alpha: 0.95
    ).cgColor
    
    let statusDot = NSView(frame: NSRect(x: 16, y: 16, width: 10, height: 10))
    statusDot.wantsLayer = true
    statusDot.layer?.cornerRadius = 5
    statusDot.layer?.backgroundColor = NSColor.red.cgColor
    statusDot.layer?.shadowColor = NSColor.red.cgColor
    statusDot.layer?.shadowOpacity = 0.5
    statusDot.layer?.shadowRadius = 6
    statusDot.layer?.shadowOffset = CGSize.zero
    contentView.addSubview(statusDot)
    
    statusLabel = NSTextField(labelWithString: "Recording...")
    statusLabel.frame = NSRect(x: 34, y: 12, width: 120, height: 20)
    statusLabel.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
    statusLabel.textColor = .white
    statusLabel.backgroundColor = .clear
    contentView.addSubview(statusLabel)
    
    timeLabel = NSTextField(labelWithString: "00:00")
    timeLabel.frame = NSRect(x: contentRect.width - 90, y: 12, width: 74, height: 20)
    timeLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
    timeLabel.textColor = .white
    timeLabel.alignment = .right
    timeLabel.backgroundColor = .clear
    contentView.addSubview(timeLabel)
    
    let waveformFrame = NSRect(x: 16, y: 50, width: contentRect.width - 32, height: 50)
    waveformView = WaveformView(frame: waveformFrame)
    waveformView.wantsLayer = true
    contentView.addSubview(waveformView)
    
    let buttonY: CGFloat = 110
    let buttonWidth: CGFloat = 80
    let buttonHeight: CGFloat = 36
    let buttonSpacing: CGFloat = 12
    let totalWidth = buttonWidth * 3 + buttonSpacing * 2
    let startX = (contentRect.width - totalWidth) / 2
    
    pauseButton = createButton(
      frame: NSRect(x: startX, y: buttonY, width: buttonWidth, height: buttonHeight),
      title: "Pause",
      icon: NSImage(systemSymbolName: "pause.fill", accessibilityDescription: nil)
    ) { [weak self] in
      self?.channel.invokeMethod("pauseOrResume", arguments: nil)
    }
    contentView.addSubview(pauseButton)
    
    stopButton = createButton(
      frame: NSRect(x: startX + buttonWidth + buttonSpacing, y: buttonY, width: buttonWidth, height: buttonHeight),
      title: "Stop",
      icon: NSImage(systemSymbolName: "stop.fill", accessibilityDescription: nil),
      isDestructive: true
    ) { [weak self] in
      self?.channel.invokeMethod("stop", arguments: nil)
    }
    contentView.addSubview(stopButton)
    
    minimizeButton = createButton(
      frame: NSRect(x: startX + (buttonWidth + buttonSpacing) * 2, y: buttonY, width: buttonWidth, height: buttonHeight),
      title: "Shrink",
      icon: NSImage(systemSymbolName: "arrow.down.right", accessibilityDescription: nil)
    ) { [weak self] in
      self?.toggleMinimize()
    }
    contentView.addSubview(minimizeButton)
    
    contentView.frame = contentRect
    contentView.autoresizingMask = [.width, .height]
    self.contentView = contentView
  }
  
  private func createButton(
    frame: NSRect,
    title: String,
    icon: NSImage?,
    isDestructive: Bool = false,
    action: @escaping () -> Void
  ) -> NSButton {
    let button = NSButton(frame: frame)
    button.title = title
    button.image = icon
    button.imagePosition = .imageLeft
    button.bezelStyle = .rounded
    button.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
    
    if isDestructive {
      button.layer?.backgroundColor = NSColor.red.withAlphaComponent(0.2).cgColor
      button.contentTintColor = .red
    } else {
      button.layer?.backgroundColor = NSColor(white: 0.2, alpha: 1).cgColor
      button.contentTintColor = .white
    }
    
    button.layer?.cornerRadius = 8
    button.wantsLayer = true
    button.setButtonType(.momentaryPushIn)
    
    objc_setAssociatedObject(button, "buttonAction", action, .OBJC_ASSOCIATION_COPY)
    button.target = self
    button.action = #selector(buttonClicked(_:))
    
    return button
  }
  
  @objc private func buttonClicked(_ sender: NSButton) {
    if let action = objc_getAssociatedObject(sender, "buttonAction") as? () -> Void {
      action()
    }
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
      setFrame(NSRect(x: frame.origin.x, y: frame.origin.y, width: 180, height: 40), display: true, animate: true)
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
      timeLabel.frame = NSRect(x: contentRect.width - 90, y: 12, width: 74, height: 20)
    }
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
