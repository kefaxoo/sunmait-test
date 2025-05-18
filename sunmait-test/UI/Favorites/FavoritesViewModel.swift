//
//  FavoritesViewModel.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteNews = [FavoriteNews]()
    
    init() {
        self.fetch()
    }
}

// MARK: - Fetch
extension FavoritesViewModel {
    func fetch() {
        self.favoriteNews = RealmManager.favorites.objects().compactMap({ FavoriteNews(value: $0) }).filter({ !RealmManager.blocked.isBlocked($0) })
    }
}

// MARK: - Remove
extension FavoritesViewModel {
    func remove(with id: String) {
        self.favoriteNews.removeAll(where: { $0.id == id })
        RealmManager.favorites.removeNews(with: id)
    }
}

// MARK: - Block
extension FavoritesViewModel {
    func blockNews(with id: String) {
        guard let news = self.favoriteNews.first(where: { $0.id == id }) else { return }
        
        self.favoriteNews.removeAll(where: { $0.id == id })
        RealmManager.blocked.write(BlockedNews.create(from: news))
    }
}
