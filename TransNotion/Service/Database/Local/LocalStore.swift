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

extension LocalStoreKey {
    static var localStoreKey: String { "local_store_\(type(of: self))" }
}

struct LocalStore<Coder: Codable & LocalStoreKey> {
    func isExists() -> Bool {
        UserDefaults.standard.dictionaryRepresentation().keys.contains(where: { $0 == Coder.localStoreKey })
    }
    
    func write(for coder: Coder) throws {
        let data = try JSONEncoder().encode(coder)
        UserDefaults.standard.set(data, forKey: Coder.localStoreKey)
    }
    
    func read() throws -> Coder? {
        guard let data = UserDefaults.standard.data(forKey: Coder.localStoreKey) else {
            return nil
        }
        let decoded = try JSONDecoder().decode(Coder.self, from: data)
        return decoded
    }
}
