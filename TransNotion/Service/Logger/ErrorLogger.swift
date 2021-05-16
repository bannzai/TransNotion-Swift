//
//  ErrorLogger.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/16.
//

import Foundation
import FirebaseCrashlytics

protocol ErrorLogger {
    func record(error: Swift.Error)
}
private struct _ErrorLogger: ErrorLogger {
    func record(error: Error) {
        print("error: \(error)")
        Crashlytics.crashlytics().record(error: error)
    }
}

let errorLogger: ErrorLogger = _ErrorLogger()
