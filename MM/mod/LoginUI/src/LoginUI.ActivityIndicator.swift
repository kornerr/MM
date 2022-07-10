import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  let style: UIActivityIndicatorView.Style

  func makeUIView(
    context: UIViewRepresentableContext<ActivityIndicator>
  ) -> UIActivityIndicatorView {
    UIActivityIndicatorView(style: style)
  }

  func updateUIView(
    _ uiView: UIActivityIndicatorView,
    context: UIViewRepresentableContext<ActivityIndicator>
  ) {
    uiView.startAnimating()
  }
}
