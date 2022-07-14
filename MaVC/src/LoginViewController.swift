import Anchorage
import UIKit

class LoginViewController: UIViewController {
  let form = UIView()
  let headerTitle = UILabel()
  let userNameLabel = UILabel()
  let userNameTextField = UITextField()
  let userNameTextFieldBG = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
    updateUI()
  }

  private func setupUI() {
    view.addSubview(headerTitle)
    view.addSubview(form)
    form.addSubview(userNameLabel)
    form.addSubview(userNameTextFieldBG)
    userNameTextFieldBG.addSubview(userNameTextField)

    headerTitle.leftAnchor /==/ view.leftAnchor + 8
    headerTitle.rightAnchor /==/ view.rightAnchor - 8
    headerTitle.bottomAnchor /==/ form.topAnchor - 8
    headerTitle.textAlignment = .center

    form.horizontalAnchors /==/ view.horizontalAnchors
    form.centerYAnchor /==/ view.centerYAnchor

    userNameLabel.leftAnchor /==/ form.leftAnchor + 16
    userNameLabel.rightAnchor /==/ userNameTextFieldBG.leftAnchor + 8
    userNameLabel.centerYAnchor /==/ userNameTextFieldBG.centerYAnchor

    //let insetsUNTF = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: -8)
    userNameTextField.edgeAnchors /==/ userNameTextFieldBG.edgeAnchors + 8
    userNameTextFieldBG.topAnchor /==/ form.topAnchor + 16
    userNameTextFieldBG.rightAnchor /==/ form.rightAnchor - 16
    userNameTextFieldBG.layer.borderWidth = 1
    userNameTextFieldBG.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor


    /**/userNameTextFieldBG.bottomAnchor /==/ form.bottomAnchor - 16

    /**///form.heightAnchor /==/ 50

  }

  private func updateUI() {
    headerTitle.text = "🎃 Murk in Models 🎃"
    userNameLabel.text = "Username:"
    userNameTextField.placeholder = "Username"
  }
}

