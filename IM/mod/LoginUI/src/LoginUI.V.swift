import Anchorage
import UIKit

extension LoginUI {
  public final class V: UIView {
    public weak var delegate: LoginUIVDelegate?

    private struct Field {
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
    private let username = Field()
    private let version = UILabel()

    override public init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
      setupEditing()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }
  }
}

// MARK: - Поля ввода.

extension LoginUI.V {
  public var hostLabel: String {
    get {
      host.label.text ?? ""
    }
    set {
      host.label.text = newValue
    }
  }

  public var hostLogo: UIImage? {
    get {
      headerLogo.image
    }
    set {
      headerLogo.image = newValue
    }
  }

  public var passwordLabel: String {
    get {
      password.label.text ?? ""
    }
    set {
      password.label.text = newValue
    }
  }

  public var usernameLabel: String {
    get {
      username.label.text ?? ""
    }
    set {
      username.label.text = newValue
    }
  }

  private func setupEditing() {
    username.textField.addTarget(self, action: #selector(usernameDidChange), for: .editingChanged)
    password.textField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
    host.textField.addTarget(self, action: #selector(hostDidChange), for: .editingChanged)
  }

  @objc private func hostDidChange(_: UITextField) {
    delegate?.hostDidChange(hostLabel)
  }

  @objc private func passwordDidChange(_: UITextField) {
    delegate?.passwordDidChange(passwordLabel)
  }

  @objc private func usernameDidChange(_: UITextField) {
    delegate?.usernameDidChange(usernameLabel)
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

    setupField(username)
    username.textField.keyboardType = .alphabet
    setupField(password)
    password.textField.keyboardType = .alphabet
    password.textField.isSecureTextEntry = true
    setupField(host)
    host.textField.keyboardType = .URL

    username.textFieldBG.topAnchor /==/ form.topAnchor + 16
    username.textFieldBG.bottomAnchor /==/ password.textFieldBG.topAnchor - 24
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
