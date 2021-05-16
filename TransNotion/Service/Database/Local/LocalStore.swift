//
//  LocalStore.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/16.
//

import Foundation

protocol LocalStoreKey {
    static var localStoreKey: String { get }
}

extension LocalStoreKey where Self: Codable {
    static var localStoreKey: String { "\(type(of: Self.self))" }
}

extension Array where Element: LocalStoreKey {
    static var localStoreKey: String { "array_\(type(of: Element.self))" }
}

struct LocalStore<Coder: Codable & LocalStoreKey> {
    private var url: URL {
        let url = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!
        let dataUrl = url.appendingPathComponent("\(type(of: Coder.localStoreKey)).json")
        return dataUrl
    }
    
    func write(for coder: Coder) throws {
        let data = try JSONEncoder().encode(coder)
        try data.write(to: url)
    }
    
    func read() throws -> Coder? {
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(Coder.self, from: data)
        return decoded
    }
}
