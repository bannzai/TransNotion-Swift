//
//  Widnow.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/16.
//

import UIKit
import SwiftUI

typealias KeyWindowClosure = () -> UIWindow?

struct KeyWindowKey: EnvironmentKey {
    static let defaultValue: KeyWindowClosure = { nil }
}

extension EnvironmentValues {
    var keyWindow: KeyWindowClosure {
        get {
            self[KeyWindowKey.self]
        }
        set {
            self[KeyWindowKey.self] = newValue
        }
    }
}
