//
//  Notion.Object.Page+Extension.swift
//  TransNotion
//
//  Created by 廣瀬雄大 on 2021/06/22.
//

import Foundation
import notion

extension Object.Page {
    private var publishedPageID: String {
        id.replacingOccurrences(of: "-", with: "")
    }
    
    func pageURL() -> URL? {
        .init(string: "https://www.notion.so/\(publishedPageID)")
    }
}
