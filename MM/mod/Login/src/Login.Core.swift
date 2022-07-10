import Combine
import LoginUI
import Net
import SwiftUI

extension Login {
  public final class Core {
    let ctrl: Controller
    let ui = LoginUI.VC()
    var subscriptions = [AnyCancellable]()
    private let resultSystemInfo = PassthroughSubject<Net.SystemInfo?, Never>()
    private let vm = LoginUI.VM()

    public init() {
      ctrl =
        Controller(
          vm.signIn.eraseToAnyPublisher(),
          vm.$host.removeDuplicates().eraseToAnyPublisher(),
          vm.$password.removeDuplicates().eraseToAnyPublisher(),
          resultSystemInfo.eraseToAnyPublisher(),
          vm.$username.removeDuplicates().eraseToAnyPublisher()
        )

      ui.content = UIHostingController(rootView: LoginUI.V(vm))
      vm.hostLabel = "Host"
      vm.passwordLabel = "Password"
      vm.usernameLabel = "Username"
      vm.version = "Version: MM-1"

      // Форматируем поле host.
      ctrl.m
        .compactMap { $0.shouldResetHost }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] v in self?.vm.host = v }
        .store(in: &subscriptions)

      // Форматируем поле password.
      ctrl.m
        .compactMap { $0.shouldResetPassword }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] v in self?.vm.password = v }
        .store(in: &subscriptions)

      // Форматируем поле username.
      ctrl.m
        .compactMap { $0.shouldResetUsername }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] v in self?.vm.username = v }
        .store(in: &subscriptions)

      // Загружаем информацию о системе при смене хоста.
      ctrl.m
        .map { $0.shouldRefreshSystemInfo }
        .removeDuplicates()
        .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
        .compactMap { $0 }
        .flatMap {
          URLSession.shared.dataTaskPublisher(for: $0)
            .map { try? JSONDecoder().decode(Net.SystemInfo.self, from: $0.data) }
            .catch { _ in Just(nil) }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] info in self?.resultSystemInfo.send(info) }
        .store(in: &subscriptions)

      // Отображаем имя хоста.
      ctrl.m
        /**/.handleEvents(receiveOutput: { _ in print("ИГР LoginC.init shouldRHN-1") })
        .map { $0.shouldResetHostName }
        /**/.handleEvents(receiveOutput: { _ in print("ИГР LoginC.init shouldRHN-2") })
        .removeDuplicates()
        /**/.handleEvents(receiveOutput: { _ in print("ИГР LoginC.init shouldRHN-3") })
        .receive(on: DispatchQueue.main)
        .sink { [weak self] v in self?.vm.hostName = v }
        .store(in: &subscriptions)
    }
  }
}
