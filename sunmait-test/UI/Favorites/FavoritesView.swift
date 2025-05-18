//
//  FavoritesView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    @Binding var showBlockAlert: Bool
    @Binding var shouldBlockNews: Bool
    
    @State private var blockNewsId: String?
    
    var body: some View {
        if self.viewModel.favoriteNews.isEmpty {
            Spacer()
            NoFavoriteView()
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.viewModel.favoriteNews, id: \.id) {
                        NewsItemView(news: $0, contentType: .favorites, blockNewsId: $blockNewsId) {
                            self.viewModel.remove(with: $0)
                        }
                    }
                }
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
}

#Preview {
    MainView()
}
