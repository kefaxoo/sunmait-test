//
//  TestAPI.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

enum TestAPI {
    case navigationBlocks
    case news(page: Int)
}

extension TestAPI: BaseAPIProtocol {
    var baseUrl: String { "https://us-central1-server-side-functions.cloudfunctions.net" }
    
    var path: String {
        switch self {
            case .navigationBlocks:
                "/navigation"
            case .news:
                "/guardian"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: Headers? {
        ["Authorization": "bahdan-piatrouski"]
    }
    
    var parameters: Parameters? {
        switch self {
            case .news(let page):
                ["page": page]
            default:
                nil
        }
    }
}
