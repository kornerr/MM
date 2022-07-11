import Combine
import MPAK
import Net

extension Login.Core {
  public final class Controller: MPAK.Controller<Model> {

    public init(
      _ didPressSignIn: AnyPublisher<Void, Never>,
      _ host: AnyPublisher<String, Never>,
      _ isLoadingSystemInfo: AnyPublisher<Void, Never>,
      _ password: AnyPublisher<String, Never>,
      _ resultHostLogo: AnyPublisher<UIImage?, Never>,
      _ resultSystemInfo: AnyPublisher<Net.SystemInfo?, Never>,
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
        dbg: "isLSI",
        Publishers.Merge(
          isLoadingSystemInfo.map { _ in true },
          resultSystemInfo.map { _ in false }
        ).eraseToAnyPublisher(),
        { $0.isLoadingSystemInfo = $1 }
      )

      pipeValue(
        dbg: "password",
        password,
        { $0.password = $1 }
      )

      pipeOptional(
        dbg: "resultSI",
        resultSystemInfo,
        { $0.systemInfo = $1 }
      )

      pipeValue(
        dbg: "resultHL",
        resultHostLogo,
        { $0.hostLogo = $1 }
      )

      pipeValue(
        dbg: "username",
        username,
        { $0.username = $1 }
      )
    }
  }
}
