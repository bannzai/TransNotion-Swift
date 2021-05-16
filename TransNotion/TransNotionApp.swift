//
//  TransNotionApp.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import SwiftUI

@main
struct TransNotionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.keyWindow, {
                    UIApplication
                        .shared
                        .connectedScenes
                        .filter({ $0.activationState == .foregroundActive })
                        .map({ $0 as? UIWindowScene })
                        .compactMap({ $0 })
                        .flatMap(\.windows)
                        .first(where: \.isKeyWindow)
                })
        }
    }
}
