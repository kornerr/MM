import Anchorage
import UIKit

extension LoginUI {
  public final class V: UIView {
    struct Field {
      let label = UILabel()
      let textField = UITextField()
      let textFieldBG = UIView()
    }

    private let form = UIView()
    private let headerLogo = UIImageView()
    private let headerTitle = UILabel()
    private let host = Field()
    private let hostActivityIndicator = UIActivityIndicatorView(style: .medium)
    private let password = Field()
    private let userName = Field()
    private let version = UILabel()

    override public init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
  }
}

// MARK: - Поля аля VM.

extension LoginUI.V {
  public var hostLabel = "" {
    didSet {
      host.label.text = hostLabel
    }
  }

  public var hostLogo: UIImage? {
    didSet {
      headerLogo.image = hostLogo
    }
  }

  public var passwordLabel = "" {
    didSet {
      password.label.text = passwordLabel
    }
  }

  public var usernameLabel = "" {
    didSet {
      username.label.text = usernameLabel
    }
  }
}

// MARK: - Вёрстка

extension LoginUI.V {
  private func setupField(_ field: Field) {
    form.addSubview(field.label)
    form.addSubview(field.textFieldBG)
    field.textFieldBG.addSubview(field.textField)

    field.label.leftAnchor /==/ form.leftAnchor + 16
    field.label.rightAnchor /==/ field.textFieldBG.leftAnchor - 8
    field.label.centerYAnchor /==/ field.textFieldBG.centerYAnchor
    field.textField.edgeAnchors /==/ field.textFieldBG.edgeAnchors + 8
    field.textFieldBG.rightAnchor /==/ form.rightAnchor - 16

    field.label.font = /*UIFont*/.preferredFont(forTextStyle: .body)
    field.textField.autocapitalizationType = .none
    field.textField.autocorrectionType = .no
    field.textFieldBG.layer.borderWidth = 1
    field.textFieldBG.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
  }

  private func setupUI() {
    addSubview(headerLogo)
    addSubview(headerTitle)
    addSubview(form)
    addSubview(version)
    form.addSubview(hostActivityIndicator)

    headerLogo.centerXAnchor /==/ centerXAnchor
    headerLogo.centerYAnchor /==/ centerYAnchor - 220
    headerLogo.widthAnchor /==/ headerLogo.heightAnchor
    headerLogo.heightAnchor /==/ 100
    headerLogo.contentMode = .scaleAspectFill
    headerLogo.layer.cornerRadius = 100 / 2
    headerLogo.clipsToBounds = true

    headerTitle.leftAnchor /==/ leftAnchor + 8
    headerTitle.rightAnchor /==/ rightAnchor - 8
    headerTitle.centerYAnchor /==/ centerYAnchor - 140
    headerTitle.textAlignment = .center
    headerTitle.font = /*UIFont*/.preferredFont(forTextStyle: .title1)
    headerTitle.numberOfLines = 1

    form.horizontalAnchors /==/ horizontalAnchors + 8
    form.centerYAnchor /==/ centerYAnchor
    form.layer.borderWidth = 1
    form.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor

    setupField(userName)
    userName.textField.addTarget(self, action: #selector(userNameDidChange), for: .editingChanged)
    userName.textField.keyboardType = .alphabet
    setupField(password)
    password.textField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
    password.textField.keyboardType = .alphabet
    password.textField.isSecureTextEntry = true
    setupField(host)
    host.textField.addTarget(self, action: #selector(hostDidChange), for: .editingChanged)
    host.textField.keyboardType = .URL

    userName.textFieldBG.topAnchor /==/ form.topAnchor + 16
    userName.textFieldBG.bottomAnchor /==/ password.textFieldBG.topAnchor - 24
    password.textFieldBG.bottomAnchor /==/ host.textFieldBG.topAnchor - 24
    host.textFieldBG.bottomAnchor /==/ form.bottomAnchor - 16

    hostActivityIndicator.centerYAnchor /==/ host.textFieldBG.centerYAnchor
    hostActivityIndicator.rightAnchor /==/ host.textFieldBG.leftAnchor - 8
    hostActivityIndicator.hidesWhenStopped = true

    version.horizontalAnchors /==/ horizontalAnchors
    version.centerYAnchor /==/ centerYAnchor + 120
    version.font = /*UIFont*/.preferredFont(forTextStyle: .footnote)
    version.textAlignment = .center
  }
}


extension LoginViewController {
  var labelWidth: CGFloat {
    let font = UIFont.preferredFont(forTextStyle: .body)
    let attrs = [NSAttributedString.Key.font: font]
    var maxLength: CGFloat = 0
    for label in fieldLabels {
      let length = (label as NSString).size(withAttributes: attrs).width
      maxLength = max(maxLength, length)
    }
    let delta = (":" as NSString).size(withAttributes: attrs).width
    return ceil(maxLength + delta)
  }

  private func loadHostLogo(_ url: URL) {
    loadHostLogoTask?.cancel()
    loadHostLogoTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      DispatchQueue.main.async {
        self?.hostLogo = UIImage(data: data ?? Data())
      }
    }
    loadHostLogoTask?.resume()
  }

  private func loadSystemInfo(_ url: URL) {
    hostActivityIndicator.startAnimating()
    loadSystemInfoTask?.cancel()
    loadSystemInfoTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.systemInfo = try? JSONDecoder().decode(SystemInfo.self, from: data ?? Data())
        self.hostActivityIndicator.stopAnimating()
      }
    }
    loadSystemInfoTask?.resume()
  }

  private func tryLoadingHostLogo() {
    if
      let host = lastHost,
      !host.isEmpty,
      let id = systemInfo?.domain.logoResourceId,
      let url = URL(string: "http://\(host)/resource/\(id)")
    {
      loadHostLogo(url)
    } else {
      hostLogo = nil
    }
  }

  private func updateField(_ field: Field, _ title: String) {
    field.label.text = "\(title):"
    field.textField.placeholder = title
    field.label.widthAnchor /==/ labelWidth
  }

  private func updateUI() {
    headerTitle.text = systemInfo?.domain.name ?? "🎃 Murk in Models 🎃"

    updateField(userName, fieldLabels[0])
    updateField(password, fieldLabels[1])
    updateField(host, fieldLabels[2])

    version.text = "Version: MaVC-1"
  }
}

extension LoginViewController {
  @objc private func hostDidChange(tf: UITextField) {
    /**/print("ИГР LoginVC.hostDC-1: '\(String(describing: tf.text))'")
    guard
      let host = tf.text,
      host != lastHost,
      let url = URL(string: "http://\(host)/systemInfo")
    else {
      return
    }
    /**/print("ИГР LoginVC.hostDC-2: '\(String(describing: tf.text))'")
    lastHost = host
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      // Удостоверяемся, что редактирование прекратилось.
      guard
        let self = self,
        host == self.lastHost
      else {
        return
      }
      self.loadSystemInfo(url)
    }
  }

  @objc private func passwordDidChange(tf: UITextField) {
    /**/print("ИГР LoginVC.passwordDC: '\(String(describing: tf.text))'")
  }

  @objc private func userNameDidChange(tf: UITextField) {
    /**/print("ИГР LoginVC.userNDC: '\(String(describing: tf.text))'")
  }
}
