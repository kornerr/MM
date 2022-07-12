import Anchorage
import UIKit

class LoginViewController: UIViewController {
  let form = UIView()
  let headerTitle = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupUI()
  }

  private func setupUI() {
    view.addSubview(form)

    form.horizontalAnchors /==/ view.horizontalAnchors
    form.centerYAnchor /==/ view.centerYAnchor
    /**/form.heightAnchor /==/ 50

    view.addSubview(headerTitle)
    headerTitle.leftAnchor /==/ view.leftAnchor + 8
    headerTitle.rightAnchor /==/ view.rightAnchor - 8
    headerTitle.bottomAnchor /==/ form.topAnchor - 8
    headerTitle.textAlignment = .center
    headerTitle.text = "🎃 Murk in Models 🎃";
  }
}

