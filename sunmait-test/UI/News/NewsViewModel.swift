//
//  NewsViewModel.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

final class NewsViewModel: ObservableObject {
    var navigationBlocks = [NavigationBlock]()
    var news = [News]()
    
    @Published var hasError = false
    @Published var totalRows = 0
    @Published var isLoadingMore = false
    
    private var currentPage = 0
    private var canPagginate = false
    
    init() {
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
                    self?.canPagginate = response.canPaggiate
                    dispatchGroup.leave()
                case .failure(let error):
                    self?.parseNewsError(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.countRowCount()
        }
    }
    
    func news(for displayIndex: Int) -> News {
        let arrayIndex = displayIndex - displayIndex / 3
        return self.news[arrayIndex]
    }
    
    private func countRowCount() {
        self.totalRows = self.news.count + self.news.count / 2
    }
}

// MARK: - Pagginate
extension NewsViewModel {
    func loadMore() {
        guard !self.isLoadingMore,
              self.canPagginate
        else { return }
        
        self.isLoadingMore = true
        TestAPIService.shared.news(page: self.currentPage + 1) { [weak self] result in
            self?.isLoadingMore = false
            switch result {
                case .success(let response):
                    self?.news += response.results
                    self?.currentPage = response.currentPage
                    self?.canPagginate = response.canPaggiate
                    self?.countRowCount()
                case .failure(let error):
                    self?.parseNewsError(error)
            }
        }
    }
    
    private func parseNewsError(_ error: any Error) {
        if let testError = error as? TestError {
            self.canPagginate = testError.reason == "Content API does not support paging this far. Please change page or page-size or consider filtering using a date range."
        } else {
            self.hasError = true
        }
    }
}
