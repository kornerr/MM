public struct Domain: Codable {
  public var name: String
  public var logoResourceId: String?
}

public struct SystemInfo: Codable {
  public var apiVersion: String
  public var domain: Domain
}
