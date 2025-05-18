//
//  News.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

struct NewsResponseWrapper: Decodable {
    let response: NewsResponseInfo
}

struct NewsResponseInfo: Decodable {
    let currentPage: Int
    let pages: Int
    let results: [News]
    
    var canPaginate: Bool {
        self.currentPage + 1 <= self.pages
    }
}

struct News: Decodable, NewsProtocol {
    var webPublicationDate: String
    
    var id: String
    var webTitle: String
    var webUrl: String
    var pillarName: String
}
