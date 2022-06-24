extension Login {
  public final class Service {
    public private(set) var core: Core?
    private var wnd: UIWindow?

    public init() { }

    private func startCore() {
      let core = Core()
      self.core = core
      core.ui.modalPresentationStyle = .overFullScreen
      wnd = Self.createWindow()
      wnd?.rootViewController?.present(core.ui, animated: true)
    }

    private func stopCore() {
      core?.ui.dismiss(animated: true)
      core = nil
      wnd = nil
    }

    private static func createWindow() -> UIWindow {
      let wnd = UIWindow(frame: UIScreen.main.bounds)
      wnd.backgroundColor = .clear
      wnd.rootViewController = UIViewController()
      wnd.makeKeyAndVisible()
      return wnd
    }
  }
}
