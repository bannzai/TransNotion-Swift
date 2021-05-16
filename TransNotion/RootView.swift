//
//  RootView.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        LoginView()
            .environmentObject(State())
    }
}

extension RootView {
    final class State: ObservableObject {
        @Published var isLogin: Bool = {
           let store = LocalStore<Credentials>()
            do {
                let credentials = try store.read()
                return credentials?.elements.last != nil
            } catch {
                return false
            }
        }()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
