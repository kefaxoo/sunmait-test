//
//  RealmManager.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import Foundation
import RealmSwift

final class RealmManager<T> where T: Object {
    static var favorites: RealmManager<FavoriteNews> {
        RealmManager<FavoriteNews>()
    }
    
    static var blocked: RealmManager<BlockedNews> {
        RealmManager<BlockedNews>()
    }
    
    private lazy var realm = try? Realm()
    
    func objects() -> [T] {
        guard let realmObjects = self.realm?.objects(T.self) else { return [] }
        
        return Array(realmObjects)
    }
    
    func setObjects() -> Set<T> {
        guard let realmObjects = self.realm?.objects(T.self) else { return [] }
        
        return Set(realmObjects)
    }
    
    func write(_ object: T, completionHandler: (() -> Void)? = nil) {
        try? self.realm?.write { [weak self] in
            self?.realm?.add(object)
            completionHandler?()
        }
    }
    
    func remove(_ object: T) {
        try? self.realm?.write { [weak self] in
            self?.realm?.delete(object)
        }
    }
    
    func write(news: any NewsProtocol & Decodable, completionHandler: (() -> Void)?) where T: RealmNewsProtocol {
        self.write(news.toRealmObject(T.self), completionHandler: completionHandler)
    }
    
    func removeNews(with id: String) where T: RealmNewsProtocol & Object {
        guard let object = self.setObjects().first(where: { $0.id == id }) else { return }
        
        self.remove(object)
    }
}

// MARK: - Favorites
extension RealmManager where T == FavoriteNews {
    func isFavorite(_ news: any NewsProtocol) -> Bool {
        Set(self.setObjects().compactMap(\.id)).contains(news.id)
    }
}

// MARK: - Blocked
extension RealmManager where T == BlockedNews {
    func isBlocked(_ news: any NewsProtocol) -> Bool {
        Set(self.setObjects().compactMap(\.id)).contains(news.id)
    }
}
