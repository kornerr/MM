extension Login.Service {
  public struct Model {
    public var core: Login.Core.Model?
    public var isAccessTokenValid = false
  }
}

extension Login.Service.Model {
  // Следует запустить новый экземпляр Core, если:
  // 1. нет действующего access token
  // 2. нет уже созданного экземпляра Core
  public var shouldStartCore: Bool {
    !isAccessTokenValid && core == nil
  }
}
