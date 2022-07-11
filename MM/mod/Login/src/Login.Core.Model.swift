import Net

extension Login.Core {
  public struct Model {
    public struct Buttons {
      public var isSignInPressed = false
    }

    public var buttons = Buttons()
    public var host = ""
    public var hostLogo: UIImage?
    public var isLoadingSystemInfo = false
    public var password = ""
    public var systemInfo: Net.SystemInfo?
    public var username = ""
  }
}

extension Login.Core.Model {
  // Стоит обновить логотип хоста.
  public var shouldRefreshHostLogo: URL? {
    guard
      !host.isEmpty,
      let id = systemInfo?.domain.logoResourceId
    else {
      return nil
    }
    let urlString = "http://\(host)/resource/\(id)"
    return URL(string: urlString)
  }

  // Стоит обновить информацию о системе по адресу хоста.
  public var shouldRefreshSystemInfo: URL? {
    guard !host.isEmpty else { return nil }
    let urlString = "http://\(host)/systemInfo"
    return URL(string: urlString)
  }

  // Приводим значение поля host к нужному формату, если есть по краям пробелы.
  public var shouldResetHost: String? {
    let th = host.trimmingCharacters(in: .whitespaces)
    if th != host {
      return th
    }
    return nil
  }

  // Стоит отобразить имя хоста.
  public var shouldResetHostName: String {
    if let si = systemInfo {
      return si.domain.name
    }
    return "🎃 Murk in Models 🎃"
  }

  // Приводим значение поля password к нужному формату, если есть по краям пробелы.
  public var shouldResetPassword: String? {
    let tp = password.trimmingCharacters(in: .whitespaces)
    if tp != password {
      return tp
    }
    return nil
  }

  // Приводим значение поля username к нужному формату, если есть по краям пробелы.
  public var shouldResetUsername: String? {
    let tu = username.trimmingCharacters(in: .whitespaces)
    if tu != username {
      return tu
    }
    return nil
  }
}
