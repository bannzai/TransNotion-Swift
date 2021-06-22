//
//  Environment+notion.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/17.
//

import Foundation
import notion
import SwiftUI

struct NotionAPIClientKey: EnvironmentKey {
    static let defaultValue: notion.Session = .shared
}

extension EnvironmentValues {
    var notion: notion.Session {
        get {
            self[NotionAPIClientKey.self]
        }
        set {
            self[NotionAPIClientKey.self] = newValue
        }
    }
}
