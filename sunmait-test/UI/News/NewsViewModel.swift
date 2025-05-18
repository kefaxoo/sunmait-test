//
//  NewsViewModel.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

final class NewsViewModel: ObservableObject {
    // MARK: - Paginate
    @Published var isLoadingMore = false
    private var currentPage = 0
    private var canPaginate = false
    
    // MARK: - Refresh
    private var isRefreshing = false
    
    // MARK: - Published
    @Published var initialLoading = true
    @Published var showSmthWentWrongAlert = false
    
    // MARK: - Content
    @Published var news = [News]()
    @Published var totalRows = 0
    var navigationBlocks = [NavigationBlock]()
    
    init() {
        if TestAPIService.shared.hasCache {
            self.initialLoading = false
            self.loadFromCache()
        } else {
            self.initialFetch()
        }
    }
}

// MARK: - Network
extension NewsViewModel {
    func initialFetch() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        TestAPIService.shared.navigationBlocks { [weak self] result in
            dispatchGroup.leave()
            guard NetworkManager.shared.isConnected else { return }
            
            switch result {
                case .success(let navigationBlocks):
                    guard navigationBlocks.count == 3 else {
                        self?.showSmthWentWrongAlert = true
                        return
                    }
                    
                    TestAPIService.shared.cachedNavigationBlocks = navigationBlocks
                    self?.navigationBlocks = navigationBlocks
                case .failure:
                    self?.showSmthWentWrongAlert = true
            }
        }
        
        dispatchGroup.enter()
        TestAPIService.shared.news { [weak self] result in
            dispatchGroup.leave()
            guard NetworkManager.shared.isConnected else { return }
            
            switch result {
                case .success(let response):
                    TestAPIService.shared.cachedNewsResponseInfo = [response]
                    self?.news = response.results.filter({ !RealmManager.blocked.isBlocked($0) })
                    self?.currentPage = response.currentPage
                    self?.canPaginate = response.canPaginate
                case .failure(let error):
                    self?.parseNewsError(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            self.initialLoading = false
            if !self.news.isEmpty,
               !self.navigationBlocks.isEmpty {
                self.calculateRowCount()
            }
        }
    }
    
    func loadFromCache() {
        self.navigationBlocks = TestAPIService.shared.cachedNavigationBlocks
        self.news = TestAPIService.shared.cachedNewsResponseInfo.reduce([], { $0 + $1.results }).filter({ !RealmManager.blocked.isBlocked($0) })
        let lastCurrentPage = TestAPIService.shared.cachedNewsResponseInfo.compactMap({ ($0.currentPage, $0.canPaginate) }).max(by: { $0.0 > $1.0 })
        self.currentPage = lastCurrentPage?.0 ?? 1
        self.canPaginate = lastCurrentPage?.1 ?? true
        self.calculateRowCount()
    }
    
    private func parseNewsError(_ error: any Error) {
        guard let testError = error as? TestError else {
            self.showSmthWentWrongAlert = true
            return
        }
        
        if testError.reason == "Content API does not support paging this far. Please change page or page-size or consider filtering using a date range." {
            self.canPaginate = false
        } else {
            self.showSmthWentWrongAlert = true
        }
    }
    
    private func setNewNews(from response: NewsResponseInfo, reset: Bool = true) {
        let news = response.results.filter({ !RealmManager.blocked.isBlocked($0) })
        if reset {
            TestAPIService.shared.cachedNewsResponseInfo = [response]
            self.news = news
        } else {
            TestAPIService.shared.cachedNewsResponseInfo.append(response)
            self.news += news
        }
        
        self.currentPage = response.currentPage
        self.canPaginate = response.canPaginate
        self.calculateRowCount()
    }
}

// MARK: Paginate
extension NewsViewModel {
    func paginate() {
        guard !self.isLoadingMore,
              self.canPaginate
        else { return }
        
        self.isLoadingMore = true
        TestAPIService.shared.news(page: self.currentPage + 1) { [weak self] result in
            self?.isLoadingMore = false
            switch result {
                case .success(let response):
                    self?.setNewNews(from: response, reset: false)
                case .failure(let error):
                    self?.parseNewsError(error)
            }
        }
    }
}

// MARK: Refresh
extension NewsViewModel {
    func refresh() async {
        guard !self.isRefreshing else { return }
        
        self.isRefreshing = true
        
        await withCheckedContinuation { continuation in
            TestAPIService.shared.news { [weak self] result in
                self?.isRefreshing = false
                continuation.resume()
                switch result {
                    case .success(let response):
                        self?.setNewNews(from: response)
                    case .failure(let error):
                        self?.parseNewsError(error)
                }
            }
        }
    }
    
    func refresh() {
        self.initialLoading = true
        Task {
            await self.refresh()
            self.initialLoading = false
        }
    }
}

// MARK: - Content
extension NewsViewModel {
    private func calculateRowCount() {
        self.totalRows = self.news.count + self.news.count / 2
    }
    
    func news(for displayIndex: Int) -> News {
        let arrayIndex = displayIndex - displayIndex / 3
        return self.news[arrayIndex]
    }
    
    func removeFavoriteNews(with id: String) {
        RealmManager.favorites.removeNews(with: id)
    }
    
    func blockNews(with id: String) {
        guard let news = self.news.first(where: { $0.id == id }) else { return }
        
        self.news.removeAll(where: { $0.id == id })
        self.calculateRowCount()
        RealmManager.blocked.write(news: news)
    }
}
