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
        HStack {
          Spacer()
          Text("Abc")
            .border(.blue)
          Spacer()
        }
          .frame(height: 300)
          .background(
            GeometryReader { geom in
              Color.clear
                .onAppear {
                  let b = UIScreen.main.bounds
                  let f = geom.frame(in: .global)
                  let shouldBeY = b.height / 2 - f.height / 2
                  /**/print("ИГР LoginUV.HStack shouldBY/frame: '\(shouldBeY)'/'\(f)'")
                }
            }
          )
          .border(.red)
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
