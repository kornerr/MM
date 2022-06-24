import Combine
import LoginUI
import SwiftUI

extension Login {
  public final class Core {
    public let ui = LoginUI.VC()
    private let vm = LoginUI.VM()

    public init() {
      ui.content = UIHostingController(rootView: LoginUI.V(vm))
    }
  }
}
