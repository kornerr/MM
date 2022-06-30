import Combine
import SwiftUI

extension LoginUI {
  public struct V: View {
    @ObservedObject var vm: VM

    public init(_ vm: VM) {
      self.vm = vm
    }

    public var body: some View {
      Text("🎃 Murk in Models 🎃")
        .font(Font.system(.title))
        .grayscale(1)
        .padding(.bottom, 16)
      VStack {
        Group {
          HStack {
            Text(vm.usernameLabel)
              .frame(width: vm.labelWidth, alignment: .leading)
            TextField("", text: $vm.username)
              .keyboardType(.alphabet)
              .padding(8)
              .border(Color.gray.opacity(0.2), width: 1)
          }
          HStack {
            Text(vm.passwordLabel)
              .frame(width: vm.labelWidth, alignment: .leading)
            SecureField("", text: $vm.password)
              .keyboardType(.alphabet)
              .padding(8)
              .border(Color.gray.opacity(0.2), width: 1)
          }
          HStack {
            Text(vm.hostLabel)
              .frame(width: vm.labelWidth, alignment: .leading)
            TextField("", text: $vm.host)
              .keyboardType(.URL)
              .padding(8)
              .border(Color.gray.opacity(0.2), width: 1)
          }
        }
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(8)
      }
        .padding(8)
        .border(Color.gray.opacity(0.2), width: 1)
        .padding(8)
      Text(vm.version)
        .font(Font.system(.footnote))
        .padding(.top, 8)
    }
  }
}
