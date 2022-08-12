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
          password
          host



          Group {
          }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(8)
        }
          .padding(16)
          .border(Color.gray.opacity(0.2), width: 1)
          .padding(8)
        Spacer()
      }
        .background(
          GeometryReader { geom in
            Color.clear
          
              .onAppear {
                /**/print("ИГР LoginUV.VStack frame: '\(geom.frame(in: .global))'")
              }
          }
        )
        .border(.yellow)
        .edgesIgnoringSafeArea(.all)
        .animation(.easeInOut(duration: 0.3))
    }

    public var _body: some View {
      VStack() {
          /*
        if let logo = vm.hostLogo {
          Image(uiImage: logo)
            .resizable()
            .scaledToFill()
            //.aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
        }
        Text(vm.hostName)
          .lineLimit(1)
          .font(Font.system(.title))
          .grayscale(1)
          .padding(.bottom, 16)
          */
        VStack {
        }
          .padding(8)
          .border(Color.gray.opacity(0.2), width: 1)
          .padding(8)
          /*
        Text(vm.version)
          .font(Font.system(.footnote))
          .padding(.top, 8)
          */
      }
      .edgesIgnoringSafeArea(.all)
      .animation(.easeInOut(duration: 0.3))
    }
  }
}

extension LoginUI.V {
  private var host: some View {
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
      .border(.blue)
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
      .border(.green)
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
      .border(.red)
  }

