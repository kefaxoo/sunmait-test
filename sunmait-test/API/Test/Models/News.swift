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

struct News: Decodable {
    fileprivate let webPublicationDate: String
    
    let id: String
    let webTitle: String
    let webUrl: String
    let pillarName: String
    
    var dateString: String? {
        guard let date = ISO8601DateFormatter().date(from: self.webPublicationDate) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
