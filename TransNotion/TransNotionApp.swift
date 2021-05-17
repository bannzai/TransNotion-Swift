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
                .environmentObject(State())
        }
    }
}

extension TransNotionApp {
    final class State: ObservableObject {
        @Published var isLogin: Bool = {
           let store = LocalStore<Credentials>()
            do {
                let credentials = try store.read()
                return credentials?.elements.last != nil
            } catch {
                print(error)
                return false
            }
        }()
        var credential: Credential? {
            let store = LocalStore<Credentials>()
             do {
                 let credentials = try store.read()
                 return credentials?.elements.last
             } catch {
                errorLogger.record(error: error)
                return nil
             }
        }
    }
}
