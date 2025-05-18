//
//  NewsProtocol.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import Foundation
import RealmSwift

protocol NewsProtocol {
    var webPublicationDate: String { get }
    var id: String { get }
    var webTitle: String { get }
    var webUrl: String { get }
    var pillarName: String { get }
    
    var dateString: String? { get }
}

extension NewsProtocol {
    var dateString: String? {
        guard let date = ISO8601DateFormatter().date(from: self.webPublicationDate) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}

extension NewsProtocol where Self: Decodable {
    func toRealmObject<T>(_ type: T.Type) -> T where T: RealmNewsProtocol {
        T.create(from: self)
    }
}
