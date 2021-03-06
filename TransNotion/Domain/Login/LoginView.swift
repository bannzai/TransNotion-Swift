//
//  LoginView.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import SwiftUI
import AuthenticationServices
import Combine

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel = .init()
    @EnvironmentObject var state: TransNotionApp.State

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            VStack {
                Text("TransNotion").font(.title).foregroundColor(.textColor)
                Button(action: {
                    viewModel.startNotionOAuth()
                }, label: {
                    HStack {
                        Image("notion_icon")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("Login with Notion")
                            .foregroundColor(.black)
                    }
                    .frame(width: 240, height: 44)
                    .background(Color.white)
                    .cornerRadius(4)
                })
            }
        }
        .onAppear {
            viewModel.onAppear(state: state)
        }
    }
}

extension LoginView {
    class ViewModel: ObservableObject {
        @Environment(\.keyWindow) var keyWindow
        @Published var credential: Credential?
        @Published var error: Error?
        var cancellables: [AnyCancellable] = []
        let localStore = LocalStore<Credentials>()
        @Published var state: TransNotionApp.State!
        
        func onAppear(state: TransNotionApp.State) {
            self.state = state
        }

        func startNotionOAuth() {
            guard let window = keyWindow() else {
                fatalError("unexpected window is not found")
            }
            NotionOAuth(window: window)
                .start()
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: { [weak self] (completion) in
                    print("Completion:", completion)
                    switch completion {
                    case .failure(let error):
                        print("Failure:", error)
                        self?.error = error
                        return
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] (credential) in
                    print("Success:", credential)
                    self?.credential = credential
                    self?.store(credential: credential)
                })
                .store(in: &cancellables)
        }
        
        private func store(credential: Credential) {
            do {
                var credentials: Credentials
                switch try localStore.read() {
                case nil:
                    credentials = .init(elements: [])
                case let _credentials?:
                    credentials = _credentials
                }
                
                credentials.elements.append(credential)
                try localStore.write(for: credentials)
                state.isLogin = true
            } catch {
                errorLogger.record(error: error)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
