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
          vm.signIn.eraseToAnyPublisher()
        )

      ui.content = UIHostingController(rootView: LoginUI.V(vm))
      vm.hostLabel = "Host:"
      vm.passwordLabel = "Password:"
      vm.usernameLabel = "Username:"
      vm.version = "Version: MM-1"
    }
  }
}
