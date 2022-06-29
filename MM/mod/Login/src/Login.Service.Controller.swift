import Combine
import MPAK

extension Login.Service {
  public final class Controller: MPAK.Controller<Model> {
    public init(
      _ core: AnyPublisher<Login.Core.Model, Never>,
      _ deleteCore: AnyPublisher<Void, Never>,
      _ isAccessTokenValid: AnyPublisher<Bool, Never>
    ) {
      super.init(
        Model(),
        debugClassName: "LoginSC",
        debugLog: { print($0) }
      )

      pipeOptional(
        dbg: "core",
        Publishers.Merge(
          core.map { $0 },
          deleteCore.map { nil }
        ).eraseToAnyPublisher(),
        { $0.core = $1 }
      )

      pipeValue(
        dbg: "isATV",
        isAccessTokenValid,
        { $0.isAccessTokenValid = $1 }
      )
    }
  }
}
