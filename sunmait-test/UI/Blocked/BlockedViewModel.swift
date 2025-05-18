//
//  BlockedViewModel.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import Foundation

final class BlockedViewModel: ObservableObject {
    @Published var blockedNews = [BlockedNews]()
    
    init() {
        self.fetch()
    }
}

// MARK: - Fetch
extension BlockedViewModel {
    func fetch() {
        self.blockedNews = RealmManager.blocked.objects().compactMap({ BlockedNews(value: $0) })
    }
}

// MARK: - Remove
extension BlockedViewModel {
    func remove(with id: String) {
        self.blockedNews.removeAll(where: { $0.id == id })
        RealmManager.blocked.removeNews(with: id)
    }
}
