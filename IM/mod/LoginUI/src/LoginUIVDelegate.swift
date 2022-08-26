public protocol LoginUIVDelegate: AnyObject {
  func hostDidChange(_: String)
  func passwordDidChange(_: String)
  func usernameDidChange(_: String)
}
