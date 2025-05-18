//
//  NewsView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    @Binding var initialLoading: Bool
    @Binding var showSmthWentWrongAlert: Bool
    @Binding var showBlockAlert: Bool
    @Binding var shouldBlockNews: Bool
    
    @State private var blockNewsId: String?
    
    var body: some View {
        VStack {
            if !self.initialLoading {
                if self.viewModel.totalRows > 0 {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(0..<self.viewModel.totalRows, id: \.self) { i in
                                if i % 3 == 2 {
                                    self.navigationBlock(for: i)
                                } else {
                                    NewsItemView(news: self.viewModel.news(for: i), contentType: .all, blockNewsId: $blockNewsId) {
                                        self.viewModel.removeFavoriteNews(with: $0)
                                    }
                                    .onAppear {
                                        self.pagination(displayIndex: i)
                                    }
                                }
                            }
                            if self.viewModel.isLoadingMore {
                                ProgressView()
                                    .setDefaultStyle()
                            }
                        }
                    }
                    .refreshable {
                        await self.viewModel.refresh()
                    }
                } else {
                    Spacer()
                    NoResultsView {
                        self.viewModel.refresh()
                    }
                    Spacer()
                }
            }
        }
        .onReceive(self.viewModel.$initialLoading) {
            self.initialLoading = $0
        }
        .onReceive(self.viewModel.$showSmthWentWrongAlert) {
            self.showSmthWentWrongAlert = $0
        }
        .onChange(of: blockNewsId) { newValue in
            guard newValue != nil else { return }
            
            self.showBlockAlert = true
        }
        .onChange(of: shouldBlockNews) { newValue in
            guard newValue,
                  let blockNewsId
            else { return }
            
            self.viewModel.blockNews(with: blockNewsId)
            self.blockNewsId = nil
            self.shouldBlockNews = false
        }
    }
}

// MARK: - UI
// MARK: Rows
private extension NewsView {
    func navigationBlock(for displayIndex: Int) -> some View {
        let realIndex = (displayIndex / 3) % 3
        return NavigationBlockView(navigationBlock: self.viewModel.navigationBlocks[realIndex])
            .onAppear {
                self.pagination(displayIndex: displayIndex)
            }
    }
}

// MARK: - Pagination
private extension NewsView {
    func pagination(displayIndex index: Int) {
        guard index >= self.viewModel.totalRows - 1 else { return }
        
        self.viewModel.paginate()
    }
}
