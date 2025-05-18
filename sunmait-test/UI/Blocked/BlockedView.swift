//
//  BlockedView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import SwiftUI

struct BlockedView: View {
    @StateObject private var viewModel = BlockedViewModel()
    
    @Binding var showUnblockAlert: Bool
    @Binding var shouldUnblockNews: Bool
    
    @State private var unblockNewsId: String?
    
    var body: some View {
        if self.viewModel.blockedNews.isEmpty {
            Spacer()
            NoBlockedView()
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.viewModel.blockedNews, id: \.id) {
                        NewsItemView(news: $0, contentType: .blocked, unblockNewsId: $unblockNewsId)
                    }
                }
            }
            .onChange(of: unblockNewsId) { newValue in
                guard newValue != nil else { return }
                
                self.showUnblockAlert = true
            }
            .onChange(of: shouldUnblockNews) { newValue in
                guard newValue,
                      let unblockNewsId
                else { return }
                
                self.viewModel.remove(with: unblockNewsId)
                self.unblockNewsId = nil
                self.shouldUnblockNews = false
            }
        }
    }
}
