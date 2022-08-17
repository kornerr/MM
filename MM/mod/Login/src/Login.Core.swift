import Combine
import LoginUI
import MPAK
import Net
import SwiftUI

extension Login {
  public final class Core: MPAK.Controller<Core.Model> {
    let ui = LoginUI.VC()
    private let isLoadingSystemInfo = PassthroughSubject<Void, Never>()
    private let resultHostLogo = PassthroughSubject<UIImage?, Never>()
    private let resultSystemInfo = PassthroughSubject<Net.SystemInfo?, Never>()
    private let vm = LoginUI.VM()

    public init() {
      super.init(
        Model(),
        debugClassName: "LoginC",
        debugLog: { print($0) }
      )

      setupPipes()
      setupUI()
      setupNetwork()
    }
  }
}

extension Login.Core {
  private func setupNetwork() {
    // Загружаем информацию о системе при смене хоста.
    m.map { $0.shouldRefreshSystemInfo }
      .removeDuplicates()
      .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
      .flatMap { [weak self] url -> AnyPublisher<Net.SystemInfo?, Never> in
        guard let url = url else { return Just(nil).eraseToAnyPublisher() }
        self?.isLoadingSystemInfo.send()
        return URLSession.shared.dataTaskPublisher(for: url)
          .map { v in try? JSONDecoder().decode(Net.SystemInfo.self, from: v.data) }
          .catch { _ in Just(nil) }
          .eraseToAnyPublisher()
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] info in self?.resultSystemInfo.send(info) }
      .store(in: &subscriptions)

    // Загружаем логотип хоста.
    m.map { $0.shouldRefreshHostLogo }
      .removeDuplicates()
      .flatMap { url -> AnyPublisher<UIImage?, Never> in
        guard let url = url else { return Just(nil).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
          .map { v in UIImage(data: v.data) }
          .catch { _ in Just(nil) }
          .eraseToAnyPublisher()
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] img in self?.resultHostLogo.send(img) }
      .store(in: &subscriptions)
  }

  private func setupPipes() {
    pipe(
      dbg: "signI",
      vm.signIn.eraseToAnyPublisher(),
      { $0.buttons.isSignInPressed = true },
      { $0.buttons.isSignInPressed = false }
    )

    pipeValue(
      dbg: "host",
      vm.$host.removeDuplicates().eraseToAnyPublisher(),
      { $0.host = $1 }
    )

    pipeValue(
      dbg: "isLSI",
      Publishers.Merge(
        isLoadingSystemInfo.map { _ in true },
        resultSystemInfo.map { _ in false }
      ).eraseToAnyPublisher(),
      { $0.isLoadingSystemInfo = $1 }
    )

    pipeValue(
      dbg: "password",
      vm.$password.removeDuplicates().eraseToAnyPublisher(),
      { $0.password = $1 }
    )

    pipeOptional(
      dbg: "resultSI",
      resultSystemInfo.eraseToAnyPublisher(),
      { $0.systemInfo = $1 }
    )

    pipeValue(
      dbg: "resultHL",
      resultHostLogo.eraseToAnyPublisher(),
      { $0.hostLogo = $1 }
    )

    pipeValue(
      dbg: "username",
      vm.$username.removeDuplicates().eraseToAnyPublisher(),
      { $0.username = $1 }
    )
  }

  private func setupUI() {
    ui.content = UIHostingController(rootView: LoginUI.V(vm))
    vm.hostLabel = "Host"
    vm.passwordLabel = "Password"
    vm.usernameLabel = "Username"
    vm.version = "Version: MM-1"

    // Форматируем поле host.
    m.compactMap { $0.shouldResetHost }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] v in self?.vm.host = v }
      .store(in: &subscriptions)

    // Форматируем поле password.
    m.compactMap { $0.shouldResetPassword }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] v in self?.vm.password = v }
      .store(in: &subscriptions)

    // Форматируем поле username.
    m.compactMap { $0.shouldResetUsername }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] v in self?.vm.username = v }
      .store(in: &subscriptions)

    // Отображаем имя хоста.
    m.map { $0.shouldResetHostName }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] v in self?.vm.hostName = v }
      .store(in: &subscriptions)

    // Отображаем факт загрузки системной инфы.
    m.map { $0.isLoadingSystemInfo }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] v in self?.vm.isLoadingSystemInfo = v }
      .store(in: &subscriptions)

    // Отображаем логотип хоста.
    m.map { $0.hostLogo }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] img in self?.vm.hostLogo = img }
      .store(in: &subscriptions)
  }
}
