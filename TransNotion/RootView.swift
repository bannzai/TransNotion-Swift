//
//  RootView.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import SwiftUI
import notion

struct RootView: View {
    @EnvironmentObject var state: TransNotionApp.State
    var body: some View {
        if state.isLogin, let credential = state.credential {
            ContentView()
                .environment(\.notion, {
                    let session = notion.Session.shared
                    session.setAuthorization(token: credential.accessToken)
                    return session
                }())
        } else {
            LoginView()
                .environmentObject(state)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
