public enum Net { }

extension Net {
  public struct Domain: Codable {
    public var name: String
    public var logoResourceId: String?
  }

  public struct SystemInfo: Codable {
    public var version: String
    public var domain: Domain
  }
}
