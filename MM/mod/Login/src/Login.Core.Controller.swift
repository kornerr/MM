import Combine
import MPAK

extension Login.Core {
  public final class Controller: MPAK.Controller<Model> {

    public init(
      _ didPressSignIn: AnyPublisher<Void, Never>
    ) {
      super.init(
        Model(),
        debugClassName: "LoginCC",
        debugLog: { print($0) }
      )

      pipe(
        dbg: "didPSI",
        didPressSignIn,
        { $0.buttons.isSignInPressed = true },
        { $0.buttons.isSignInPressed = false }
      )
    }
  }
}
