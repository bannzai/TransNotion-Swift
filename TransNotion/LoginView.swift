//
//  LoginView.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Color.background

            VStack {
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image("notion_icon")
                            .resizable()
                        Text("Login with Notion")
                    }
                    .frame()
                })
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
