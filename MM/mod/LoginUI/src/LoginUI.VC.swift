import SwiftUI

extension LoginUI {
  public final class VC: UIViewController {
    public var content: UIHostingController<LoginUI.V>?

    public override func viewDidLoad() {
      super.viewDidLoad()
      guard let content = content else { return }
      view.addSubview(content.view)
      content.view.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        content.view.topAnchor.constraint(equalTo: view.topAnchor),
        content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      ])
      addChild(content)
      content.didMove(toParent: self)
    }
  }
}
