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
            Color.background.edgesIgnoringSafeArea(.all)

            VStack {
                Button(action: {
                    
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
