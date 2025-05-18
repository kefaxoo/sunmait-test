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
                                    NewsItemView(news: self.viewModel.news(for: i), contentType: .all) {
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
                    NoResultsView()
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
