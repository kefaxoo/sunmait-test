//
//  NewsViewModel.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

final class NewsViewModel: ObservableObject {
    var navigationBlocks = [NavigationBlock]()
    
    @Published var content = [News]()
    
    @Published var hasError = false
    @Published var totalRows = 0
    @Published var isLoadingMore = false
    @Published var isRefreshing = false
    @Published var isLoading = false
    
    private var currentPage = 0
    private var canPaginate = false
    
    private var news = [News]()
    
    init() {
        self.isLoading = true
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        TestAPIService.shared.navigationBlocks { [weak self] result in
            switch result {
                case .success(let navigationBlocks):
                    guard navigationBlocks.count == 3 else {
                        self?.hasError = true
                        return
                    }
                    
                    self?.navigationBlocks = navigationBlocks
                    dispatchGroup.leave()
                case .failure:
                    self?.hasError = true
            }
        }
        
        dispatchGroup.enter()
        TestAPIService.shared.news { [weak self] result in
            switch result {
                case .success(let response):
                    self?.news = response.results
                    self?.currentPage = response.currentPage
                    self?.canPaginate = response.canPaginate
                    dispatchGroup.leave()
                case .failure(let error):
                    self?.parseNewsError(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.countRowCount()
            self?.isLoading = false
        }
    }
    
    func news(for displayIndex: Int) -> News {
        let arrayIndex = displayIndex - displayIndex / 3
        return self.news[arrayIndex]
    }
    
    private func countRowCount() {
        self.totalRows = self.news.count + self.news.count / 2
    }
    
    private func setNewNews(_ response: NewsResponseInfo, reset: Bool = true) {
        if reset {
            self.news = response.results
        } else {
            self.news += response.results
        }
        
        self.currentPage = response.currentPage
        self.canPaginate = response.canPaginate
        self.countRowCount()
    }
}

// MARK: - Paginate
extension NewsViewModel {
    func loadMore() {
        guard !self.isLoadingMore,
              self.canPaginate
        else { return }
        
        self.isLoadingMore = true
        TestAPIService.shared.news(page: self.currentPage + 1) { [weak self] result in
            self?.isLoadingMore = false
            switch result {
                case .success(let response):
                    self?.setNewNews(response, reset: false)
                case .failure(let error):
                    self?.parseNewsError(error)
            }
        }
    }
    
    private func parseNewsError(_ error: any Error) {
        if let testError = error as? TestError {
            self.canPaginate = testError.reason == "Content API does not support paging this far. Please change page or page-size or consider filtering using a date range."
        } else {
            self.hasError = true
        }
    }
}

// MARK: - Refresh
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
                        self?.setNewNews(response)
                    case .failure(let error):
                        self?.parseNewsError(error)
                }
            }
        }
    }
}

// MARK: - Change selection
extension NewsViewModel {
    func changeSelection(index: Int) {
        switch NewsContentType.allCases[index] {
            case .all:
                self.content = self.news
            default:
                break
        }
    }
}
