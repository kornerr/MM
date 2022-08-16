import Anchorage
import UIKit

class LoginViewController: UIViewController {
  struct Field {
    let label = UILabel()
    let textField = UITextField()
    let textFieldBG = UIView()
  }

  private let fieldLabels = ["Username", "Password", "Host"]
  private let form = UIView()
  private let headerLogo = UIImageView()
  private let headerTitle = UILabel()
  private let host = Field()
  private let password = Field()
  private let userName = Field()
  private let version = UILabel()
  private var hostLogo: UIImage? {
    didSet {
      updateUI()
    }
  }
  private var lastHost: String?
  private var loadHostLogoTask: URLSessionDataTask?
  private var loadSystemInfoTask: URLSessionDataTask?
  private var systemInfo: SystemInfo? {
    didSet {
      updateUI()
      tryLoadingHostLogo()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
    updateUI()
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
    loadSystemInfoTask?.cancel()
    loadSystemInfoTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      DispatchQueue.main.async {
        self?.systemInfo = try? JSONDecoder().decode(SystemInfo.self, from: data ?? Data())
      }
    }
    loadSystemInfoTask?.resume()
  }

  private func setupUI() {
    view.addSubview(headerLogo)
    view.addSubview(headerTitle)
    view.addSubview(form)
    view.addSubview(version)

    headerLogo.centerXAnchor /==/ view.centerXAnchor
    headerLogo.centerYAnchor /==/ view.centerYAnchor - 220
    headerLogo.widthAnchor /==/ headerLogo.heightAnchor
    headerLogo.heightAnchor /==/ 100
    headerLogo.contentMode = .scaleAspectFill
    headerLogo.layer.cornerRadius = 100 / 2
    headerLogo.clipsToBounds = true

    headerTitle.leftAnchor /==/ view.leftAnchor + 8
    headerTitle.rightAnchor /==/ view.rightAnchor - 8
    headerTitle.centerYAnchor /==/ view.centerYAnchor - 140
    headerTitle.textAlignment = .center
    headerTitle.font = UIFont.preferredFont(forTextStyle: .title1)
    headerTitle.numberOfLines = 1

    form.horizontalAnchors /==/ view.horizontalAnchors + 8
    form.centerYAnchor /==/ view.centerYAnchor
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

    version.horizontalAnchors /==/ view.horizontalAnchors
    version.centerYAnchor /==/ view.centerYAnchor + 120
    version.font = UIFont.preferredFont(forTextStyle: .footnote)
    version.textAlignment = .center
  }

  private func setupField(_ field: Field) {
    field.textField.autocapitalizationType = .none
    field.textField.autocorrectionType = .no

    form.addSubview(field.label)
    form.addSubview(field.textFieldBG)
    field.textFieldBG.addSubview(field.textField)

    field.label.leftAnchor /==/ form.leftAnchor + 16
    field.label.rightAnchor /==/ field.textFieldBG.leftAnchor - 8
    field.label.centerYAnchor /==/ field.textFieldBG.centerYAnchor
    field.textField.edgeAnchors /==/ field.textFieldBG.edgeAnchors + 8
    field.textFieldBG.rightAnchor /==/ form.rightAnchor - 16
    field.textFieldBG.layer.borderWidth = 1
    field.textFieldBG.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
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
    field.label.font = UIFont.preferredFont(forTextStyle: .body)
    field.label.text = "\(title):"
    field.textField.placeholder = title
    field.label.widthAnchor /==/ labelWidth
  }

  private func updateUI() {
    headerLogo.image = hostLogo
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
