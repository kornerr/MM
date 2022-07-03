import Combine
import LoginUI
import SwiftUI

extension Login {
  public final class Core {
    let ctrl: Controller
    let ui = LoginUI.VC()
    var subscriptions = [AnyCancellable]()
    private let vm = LoginUI.VM()

    public init() {
      ctrl =
        Controller(
          vm.signIn.eraseToAnyPublisher(),
          vm.$host.removeDuplicates().eraseToAnyPublisher(),
          vm.$password.removeDuplicates().eraseToAnyPublisher(),
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
    }
  }
}
