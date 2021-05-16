//
//  RootView.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var state: TransNotionApp.State
    var body: some View {
        if state.isLogin {
            ContentView()
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
