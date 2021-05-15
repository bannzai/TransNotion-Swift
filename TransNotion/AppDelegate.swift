//
//  AppDelegate.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/15.
//

import UIKit
import Firebase

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !isPreview {
            setupFirebase()
        }
        return true
    }
}

private func setupFirebase() {
    #if DEBUG
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")!)!)
    #else
    FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")!)!)
    #endif
}
