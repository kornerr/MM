import Combine
import MPAK

extension Login.Core {
  public final class Controller: MPAK.Controller<Model> {

    public init(
      _ didPressSignIn: AnyPublisher<Void, Never>,
      _ host: AnyPublisher<String, Never>,
      _ password: AnyPublisher<String, Never>,
      _ username: AnyPublisher<String, Never>
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

      pipeValue(
        dbg: "host",
        host,
        { $0.host = $1 }
      )

      pipeValue(
        dbg: "password",
        password,
        { $0.password = $1 }
      )

      pipeValue(
        dbg: "username",
        username,
        { $0.username = $1 }
      )
    }
  }
}
