//
//  FavoritesView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        if self.viewModel.favoriteNews.isEmpty {
            Spacer()
            NoFavoriteView()
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.viewModel.favoriteNews, id: \.id) {
                        NewsItemView(news: $0, contentType: .favorites) {
                            self.viewModel.remove(with: $0)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
