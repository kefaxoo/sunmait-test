//
//  NewsView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NewsView: View {
    @State private var selectedSegment = 0
    private var segments = ["All", "Favorites", "Blocked"]
    
    @StateObject private var viewModel = NewsViewModel()
    @State private var showSmthWentWrongAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 8) {
                    Picker("Select a segment", selection: $selectedSegment) {
                        ForEach(0..<segments.count, id: \.self) { index in
                            Text(self.segments[index])
                        }
                    }
                    
                    .pickerStyle(.segmented)
                    .padding(.bottom, 8)
                    ForEach(0..<self.viewModel.totalRows, id: \.self) { i in
                        if i % 3 == 2 {
                            self.navigationBlock(for: i)
                                .onAppear {
                                    self.checkRow(at: i)
                                }
                        } else {
                            NewsItemView(news: self.viewModel.news(for: i))
                                .onAppear {
                                    self.checkRow(at: i)
                                }
                        }
                    }
                    if self.viewModel.isLoadingMore {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.customGray)
                            .scaleEffect(1.5)
                            .padding(.vertical, 8)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .navigationTitle("News")
            .background(.beige)
            .alert("Something Went Wrong", isPresented: $showSmthWentWrongAlert) {
                Button {
                    self.viewModel.hasError = false
                } label: {
                    Text("OK")
                }
            }
            .onReceive(viewModel.$hasError) {
                self.showSmthWentWrongAlert = $0
            }
        }
    }
    
    func navigationBlock(for displayIndex: Int) -> NavigationBlockView {
        let realIndex = (displayIndex / 3) % 3
        return NavigationBlockView(navigationBlock: self.viewModel.navigationBlocks[realIndex])
    }
    
    func checkRow(at index: Int) {
        guard index == self.viewModel.totalRows - 1 else { return }
                
        self.viewModel.loadMore()
    }
}

#Preview {
    NewsView()
}
