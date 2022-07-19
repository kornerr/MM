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

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
    updateUI()
  }

  private func setupUI() {
    view.addSubview(headerTitle)
    view.addSubview(form)

    headerTitle.leftAnchor /==/ view.leftAnchor + 8
    headerTitle.rightAnchor /==/ view.rightAnchor - 8
    headerTitle.bottomAnchor /==/ form.topAnchor - 8
    headerTitle.textAlignment = .center

    form.horizontalAnchors /==/ view.horizontalAnchors
    form.centerYAnchor /==/ view.centerYAnchor
    form.layer.borderWidth = 1
    form.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor

    setupField(userName)
    setupField(password)
    setupField(host)
    userName.textFieldBG.topAnchor /==/ form.topAnchor + 16
    userName.textFieldBG.bottomAnchor /==/ password.textFieldBG.topAnchor - 24
    password.textFieldBG.bottomAnchor /==/ host.textFieldBG.topAnchor - 24
    host.textFieldBG.bottomAnchor /==/ form.bottomAnchor - 16
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
  }
}

