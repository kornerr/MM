extension Login.Core {
  public struct Model {
    public struct Buttons {
      public var isSignInPressed = false
    }

    public var buttons = Buttons()
    public var host = ""
    public var password = ""
    public var username = ""
  }
}

extension Login.Core.Model {
  // Стоит обновить информацию о системе по адресу хоста.
  public var shouldRefreshSystemInfo: URL? {
    host.isEmpty ? nil : URL(string: host + "/systemInfo")
  }

  // Приводим значение поля host к нужному формату, если есть по краям пробелы.
  public var shouldResetHost: String? {
    let th = host.trimmingCharacters(in: .whitespaces)
    if th != host {
      return th
    }
    return nil
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
