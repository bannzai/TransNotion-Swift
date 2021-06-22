//
//  NotionWebViewPage.swift
//  TransNotion
//
//  Created by 廣瀬雄大 on 2021/06/22.
//

import SwiftUI

struct NotionWebViewPage: View {
    @State var url: URL
    @State var isLoading = false

    var body: some View {
        VStack {
            NotionWebView(url: $url, isLoading: $isLoading)
            
            Spacer()
            
            Button("Translate this page") {
                print("TODO: Translate and extract currnet page")
                print("URL: \(url)", "isLoading: \(isLoading)")
            }
            .buttonStyle(PrimaryButtonStyle(width: 240))
            .disabled(isLoading)
            .placeholder(when: isLoading)

            Spacer().frame(height: 40)
        }
    }
}
