//
//  NewNewsViewModel.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

final class NewNewsViewModel: ObservableObject {
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
        self.initialFetch()
    }
}

// MARK: - Network
extension NewNewsViewModel {
    func initialFetch() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        TestAPIService.shared.navigationBlocks { [weak self] result in
            dispatchGroup.leave()
            switch result {
                case .success(let navigationBlocks):
                    guard navigationBlocks.count == 3 else {
                        self?.showSmthWentWrongAlert = true
                        return
                    }
                    
                    self?.navigationBlocks = navigationBlocks
                case .failure:
                    self?.showSmthWentWrongAlert = true
            }
        }
        
        dispatchGroup.enter()
        TestAPIService.shared.news { [weak self] result in
            dispatchGroup.leave()
            switch result {
                case .success(let response):
                    self?.news = response.results
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
        if reset {
            self.news = response.results
        } else {
            self.news += response.results
        }
        
        self.currentPage = response.currentPage
        self.canPaginate = response.canPaginate
        self.calculateRowCount()
    }
}

// MARK: Paginate
extension NewNewsViewModel {
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
extension NewNewsViewModel {
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
}

// MARK: - Content
extension NewNewsViewModel {
    private func calculateRowCount() {
        self.totalRows = self.news.count + self.news.count / 2
    }
    
    func news(for displayIndex: Int) -> News {
        let arrayIndex = displayIndex - displayIndex / 3
        return self.news[arrayIndex]
    }
}
