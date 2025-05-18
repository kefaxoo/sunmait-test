//
//  FavoriteNews.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import Foundation
import RealmSwift

final class FavoriteNews: Object, RealmNewsProtocol {
    @Persisted var webPublicationDate = ""
    @Persisted(primaryKey: true) var id = ""
    @Persisted var webTitle = ""
    @Persisted var webUrl = ""
    @Persisted var pillarName = ""
    
    convenience init(news: any NewsProtocol) {
        self.init()
        
        self.webPublicationDate = news.webPublicationDate
        self.id = news.id
        self.webTitle = news.webTitle
        self.webUrl = news.webUrl
        self.pillarName = news.pillarName
    }
}

extension FavoriteNews {
    static func create(from news: any NewsProtocol) -> Self {
        Self.init(news: news)
    }
}
