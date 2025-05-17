//
//  NewsView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NewsView: View {
    @State private var selectedSegment = 0
    private var segments = NewsContentType.allCases
    
    @StateObject private var viewModel = NewsViewModel()
    @State private var showSmthWentWrongAlert = false
    
    @State private var scrollOffset: CGFloat = 0
    @State private var triggerRefresh: Bool = false
    
    @State private var showBlockAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                self.segmentControl()
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
//                if self.viewModel.news.isEmpty {
//                    Spacer()
//                    NoResultsView()
//                    Spacer()
//                } else {
//                    ScrollView {
//                        LazyVStack(spacing: 8) {
//                            ForEach(0..<self.viewModel.totalRows, id: \.self) { i in
//                                switch self.segments[self.selectedSegment] {
//                                    case .all:
//                                        if i % 3 == 2 {
//                                            self.navigationBlock(for: i)
//                                        } else {
//                                            NewsItemView(news: self.viewModel.news(for: i), showBlockAlert: $showBlockAlert)
//                                                .onAppear {
//                                                    self.pagination(at: i)
//                                                }
//                                        }
//                                    default:
//                                        Text("")
//                                }
//                            }
//                            if self.viewModel.isLoadingMore {
//                                self.defaultProgressView()
//                            }
//                        }
//                    }
//                    .refreshable {
//                        await viewModel.refresh()
//                    }
//                }
            }
            .navigationTitle("News")
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
            .background(.beige)
        }
        .overlay {
            self.loadingBlurView()
            self.blockAlert()
        }
    }
}

// MARK: - UI
private extension NewsView {
    func segmentControl() -> some View {
        Picker("Select a segment", selection: $selectedSegment) {
            ForEach(0..<segments.count, id: \.self) { index in
                Text(self.segments[index].title)
            }
        }
        .pickerStyle(.segmented)
        .padding(.bottom, 8)
    }
    
    func loadingBlurView () -> some View {
        ZStack {
            if self.viewModel.isLoading {
                BlurView {
                    ProgressView()
                        .setDefaultStyle(color: .white)
                }
                .transition(.opacity)
            }
        }.animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
    }
    
    func navigationBlock(for displayIndex: Int) -> some View {
        let realIndex = (displayIndex / 3) % 3
        return NavigationBlockView(navigationBlock: self.viewModel.navigationBlocks[realIndex])
            .onAppear {
                self.pagination(at: displayIndex)
            }
    }
}

// MARK: - Alerts
private extension NewsView {
    func blockAlert() -> some View {
        ZStack {
            if self.showBlockAlert {
                BlurView {}
                    .alert("Do you want to block?", isPresented: $showBlockAlert) {
                        Button(role: .destructive) {
                            
                        } label: {
                            Text("Block")
                        }
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("Cancel")
                        }
                    } message: {
                        Text("Confirm to hide this news source")
                    }
            }
        }.animation(.easeInOut(duration: 0.3), value: showBlockAlert)
    }
}

// MARK: - Actions
private extension NewsView {
    func pagination(at index: Int) {
        guard index >= self.viewModel.totalRows - 1 else { return }
        
        self.viewModel.loadMore()
    }
}

#Preview {
    NewsView()
}
