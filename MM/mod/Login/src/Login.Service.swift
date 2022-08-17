import Combine

extension Login {
  public final class Service {
    private let coreModel = PassthroughSubject<Login.Core.Model, Never>()
    private let ctrl: Controller
    private let deleteCore = PassthroughSubject<Void, Never>()
    private var core: Core?
    private var subscriptions = [AnyCancellable]()
    private var wnd: UIWindow?

    public init() {
      ctrl =
        Controller(
          coreModel.eraseToAnyPublisher(),
          deleteCore.eraseToAnyPublisher(),
          Just(false).eraseToAnyPublisher()
        )

      // Запуск Core.
      ctrl.m
        .filter { $0.shouldStartCore }
        .receive(on: DispatchQueue.main)
        .sink { _ in self.startCore() }
        .store(in: &subscriptions)

      // Завершение Core.
      ctrl.m
        .filter { $0.isAccessTokenValid }
        .receive(on: DispatchQueue.main)
        .sink { _ in self.stopCore() }
        .store(in: &subscriptions)
    }

    private func startCore() {
      let core = Core()
      self.core = core
      core.ui.modalPresentationStyle = .overFullScreen
      wnd = Self.createWindow()
      wnd?.rootViewController?.present(core.ui, animated: true)

      // Транслируем модель Core в модель Service.
      core.m
        .receive(on: DispatchQueue.main)
        .sink { model in self.coreModel.send(model) }
        .store(in: &core.subscriptions)
    }

    private func stopCore() {
      core?.ui.dismiss(animated: true) { [weak self] in
        guard let self = self else { return }
        self.core = nil
        self.wnd = nil
      }
      // Уведомляем модель Service об исчезновении модели Core.
      deleteCore.send()
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
