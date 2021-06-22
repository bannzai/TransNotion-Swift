//
//  Notion.Object.Page+Extension.swift
//  TransNotion
//
//  Created by 廣瀬雄大 on 2021/06/22.
//

import Foundation
import notion

extension Object.Page {
    func pageEndpoint() -> String? {
        guard let titleProperty = properties.map(\.value).first(where: { $0.id == "title" }),
              case .title(let titleObject) = titleProperty.type,
              let title = titleObject.first?.plainText else {
            return nil
        }
        
        var pageEndpoint = title
        pageEndpoint = pageEndpoint.replacingOccurrences(of: " ", with: "-")
        pageEndpoint += "-" + id
        return pageEndpoint
    }
    
    func pageURL() -> URL? {
        guard let endpoint = pageEndpoint() else {
            return nil
        }
        return .init(string: "https://www.notion.so/\(endpoint)")
    }
}
