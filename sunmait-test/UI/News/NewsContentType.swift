//
//  NewsContentType.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

enum NewsContentType: CaseIterable {
    case all
    case favorites
    case blocked
}

extension NewsContentType {
    var title: String {
        switch self {
            case .all:
                "All"
            case .favorites:
                "Favorites"
            case .blocked:
                "Blocked"
        }
    }
}
