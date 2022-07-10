import Combine
import SwiftUI

extension LoginUI {
  public struct V: View {
    @ObservedObject var vm: VM

    public init(_ vm: VM) {
      self.vm = vm
    }

    public var body: some View {
      VStack {
        Text(vm.hostName)
          .lineLimit(1)
          .font(Font.system(.title))
          .grayscale(1)
          .padding(.bottom, 16)
        VStack {
          Group {
            HStack {
              Text(vm.usernameLabel + ":")
                .frame(width: vm.labelWidth, alignment: .leading)
              TextField(vm.usernameLabel, text: $vm.username)
                .keyboardType(.alphabet)
                .padding(8)
                .border(Color.gray.opacity(0.2), width: 1)
            }
            HStack {
              Text(vm.passwordLabel + ":")
                .frame(width: vm.labelWidth, alignment: .leading)
              SecureField(vm.passwordLabel, text: $vm.password)
                .keyboardType(.alphabet)
                .padding(8)
                .border(Color.gray.opacity(0.2), width: 1)
            }
            HStack {
              Text(vm.hostLabel + ":")
                .frame(width: vm.hostLabelWidth, alignment: .leading)
              if vm.isLoadingSystemInfo {
                ActivityIndicator(style: .medium)
              }
              TextField(vm.hostLabel, text: $vm.host)
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
      .animation(.easeInOut(duration: 0.3))
    }
  }
}
