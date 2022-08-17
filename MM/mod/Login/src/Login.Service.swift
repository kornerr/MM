import Combine
import MPAK

extension Login {
  public final class Service: MPAK.Controller<Service.Model> {
    private let coreModel = PassthroughSubject<Login.Core.Model, Never>()
    private let deleteCore = PassthroughSubject<Void, Never>()
    private var core: Core?
    private var wnd: UIWindow?

    public init() {
      super.init(
        Model(),
        debugClassName: "LoginS",
        debugLog: { print($0) }
      )
      setupPipes()
      setupCore()
    }
  }
}

// MARK: - Pipes

extension Login.Service {
  private func setupPipes() {
    pipeOptional(
      dbg: "core",
      Publishers.Merge(
        coreModel.map { $0 },
        deleteCore.map { nil }
      ).eraseToAnyPublisher(),
      { $0.core = $1 }
    )
  }
}

// MARK: - Core

extension Login.Service {
  private func setupCore() {
    // Запуск Core.
    m.filter { $0.shouldStartCore }
      .receive(on: DispatchQueue.main)
      .sink { _ in self.startCore() }
      .store(in: &subscriptions)
  }

  private func startCore() {
    let core = Login.Core()
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
