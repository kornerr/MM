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
        Spacer()
        VStack(spacing: 0) {
          username
            .padding(.bottom, 24)
          password
            .padding(.bottom, 24)
          host
        }
          .padding(16)
          .border(Color.gray.opacity(0.2), width: 1)
          .padding(8)
          .overlay(logo)
          .overlay(title)
          .overlay(version)
        Spacer()
      }
        .edgesIgnoringSafeArea(.all)
        .animation(.easeInOut(duration: 0.3))
    }
  }
}

// MARK: - Поля ввода

extension LoginUI.V {
  private var host: some View {
    HStack {
      Text(vm.hostLabel + ":")
        .frame(width: vm.hostLabelWidth, alignment: .leading)
      if vm.isLoadingSystemInfo {
        ActivityIndicator(style: .medium)
      }
      TextField(vm.hostLabel, text: $vm.host)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(.URL)
        .padding(8)
        .border(Color.gray.opacity(0.2), width: 1)
    }
  }

  private var password: some View {
    HStack {
      Text(vm.passwordLabel + ":")
        .frame(width: vm.labelWidth, alignment: .leading)
      SecureField(vm.passwordLabel, text: $vm.password)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(.alphabet)
        .padding(8)
        .border(Color.gray.opacity(0.2), width: 1)
    }
  }

  private var username: some View {
    HStack {
      Text(vm.usernameLabel + ":")
        .frame(width: vm.labelWidth, alignment: .leading)
      TextField(vm.usernameLabel, text: $vm.username)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(.alphabet)
        .padding(8)
        .border(Color.gray.opacity(0.2), width: 1)
    }
  }
}

// MARK: - Прочие элементы

extension LoginUI.V {
  private var logo: some View {
    VStack {
      if let img = vm.hostLogo {
        Image(uiImage: img)
          .resizable()
          .scaledToFill()
          .frame(width: 100, height: 100)
          .clipShape(Circle())
          .offset(y: -220)
      }
    }
  }

  private var title: some View {
    Text(vm.hostName)
      .lineLimit(1)
      .font(Font.system(.title))
      .grayscale(1)
      .offset(y: -140)
  }

  private var version: some View {
    Text(vm.version)
      .font(Font.system(.footnote))
      .offset(y: 120)
  }
}
