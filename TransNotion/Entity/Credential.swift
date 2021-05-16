//
//  Credential.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/16.
//

import Foundation

struct Credential: Codable {
    let accessToken: String
    let workspaceName: String
    // NOTE: workspaceIcon is exists into document. But exactly not contains in response
    let workspaceIcon: String?
    let botId: String
}

struct Credentials: Codable, LocalStoreKey {
    var elements: [Credential]
}
