import Anchorage
import UIKit

class LoginViewController: UIViewController {
  struct Field {
    let label = UILabel()
    let textField = UITextField()
    let textFieldBG = UIView()
  }

  let fieldLabels = ["Username", "Password", "Host"]
  let form = UIView()
  let headerTitle = UILabel()
  let host = Field()
  let password = Field()
  let userName = Field()
  let version = UILabel()
  var hostURL: URL?
  var loadSystemInfoTask: URLSessionDataTask?

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

  private func loadSystemInfo(_ url: URL) {
    loadSystemInfoTask?.cancel()
    loadSystemInfoTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      DispatchQueue.main.async {
        self?.processSystemInfo(data, response, error)
      }
    }
  }

  private func processSystemInfo(
    _ data: Data?,
    _ response: URLResponse?,
    _ error: Error?
  ) {
    /**/print("ИГР LoginVC.processSI data/response/error: '\(data)'/'\(response)'/'\(error)'")
  }

  private func setupUI() {
    view.addSubview(headerTitle)
    view.addSubview(form)
    view.addSubview(version)

    headerTitle.leftAnchor /==/ view.leftAnchor + 8
    headerTitle.rightAnchor /==/ view.rightAnchor - 8
    headerTitle.bottomAnchor /==/ form.topAnchor - 32
    headerTitle.textAlignment = .center
    headerTitle.font = UIFont.preferredFont(forTextStyle: .title1)
    headerTitle.numberOfLines = 1

    form.horizontalAnchors /==/ view.horizontalAnchors + 8
    form.centerYAnchor /==/ view.centerYAnchor + 16
    form.layer.borderWidth = 1
    form.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor

    setupField(userName)
    userName.textField.addTarget(self, action: #selector(userNameDidChange), for: .editingChanged)
    setupField(password)
    password.textField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
    setupField(host)
    host.textField.addTarget(self, action: #selector(hostDidChange), for: .editingChanged)
    userName.textFieldBG.topAnchor /==/ form.topAnchor + 16
    userName.textFieldBG.bottomAnchor /==/ password.textFieldBG.topAnchor - 24
    password.textFieldBG.bottomAnchor /==/ host.textFieldBG.topAnchor - 24
    host.textFieldBG.bottomAnchor /==/ form.bottomAnchor - 16

    version.horizontalAnchors /==/ view.horizontalAnchors
    version.topAnchor /==/ form.bottomAnchor + 24
    version.font = UIFont.preferredFont(forTextStyle: .footnote)
    version.textAlignment = .center
  }

  private func setupField(_ field: Field) {
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

  private func updateField(_ field: Field, _ title: String) {
    field.label.font = UIFont.preferredFont(forTextStyle: .body)
    field.label.text = "\(title):"
    field.textField.placeholder = title
    field.label.widthAnchor /==/ labelWidth
  }

  private func updateUI() {
    headerTitle.text = "🎃 Murk in Models 🎃"

    updateField(userName, fieldLabels[0])
    updateField(password, fieldLabels[1])
    updateField(host, fieldLabels[2])

    version.text = "Version: MaVC-1"
  }
}

extension LoginViewController {
  @objc private func hostDidChange(tf: UITextField) {
    /**/print("ИГР LoginVC.hostDC-1: '\(tf.text)'")
    guard
      let urlString = tf.text,
      let url = URL(string: urlString),
      url != hostURL
    else {
      return
    }
    /**/print("ИГР LoginVC.hostDC-2: '\(tf.text)'")
    hostURL = url
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
      loadSystemInfo(url)
    }
  }

  @objc private func passwordDidChange(tf: UITextField) {
    /**/print("ИГР LoginVC.passwordDC: '\(tf.text)'")
  }

  @objc private func userNameDidChange(tf: UITextField) {
    /**/print("ИГР LoginVC.userNDC: '\(tf.text)'")
  }
}
