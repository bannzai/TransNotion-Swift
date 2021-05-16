//
//  JSONCoder+Extension.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/16.
//

import Foundation

extension JSONDecoder {
    static let convertFromSnakeCase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
extension JSONEncoder {
    static let convertToSnakeCase: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
}
