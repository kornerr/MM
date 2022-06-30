import Combine
import SwiftUI

extension LoginUI {
  public struct V: View {
    @ObservedObject var vm: VM

    public init(_ vm: VM) {
      self.vm = vm
    }

    public var body: some View {
      Text("🎃 Enter Murk in Models 🎃")
        .padding(32)
      Group {
        VStack(alignment: .leading) {
          Text("Username:")
          TextField("", text: $vm.username)
            .keyboardType(.alphabet)
            .padding(8)
            .border(Color.gray, width: 1)
        }
        VStack(alignment: .leading) {
          Text("Password:")
          SecureField("", text: $vm.password)
            .keyboardType(.alphabet)
            .padding(8)
            .border(Color.gray, width: 1)
        }
        VStack(alignment: .leading) {
          Text("Host:")
          TextField("", text: $vm.host)
            .keyboardType(.URL)
            .padding(8)
            .border(Color.gray, width: 1)
        }
      }
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .padding([.leading, .trailing, .bottom], 24)
    }
  }
}
