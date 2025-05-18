//
//  MainView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct MainView: View {
    // MARK: - Private
    // MARK: Segment
    @State private var selectedSegment = 0
    
    // MARK: Alerts
    @State private var showSmthWentWrongAlert = false
    @State private var showBlockAlert = false
    @State private var showUnblockAlert = false
    
    // MARK: Initial
    @State private var initialLoading = true
    
    // MARK: Block News
    @State private var shouldBlockNews = false
    @State private var shouldUnblockNews = false
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if !self.initialLoading {
                    Picker("", selection: $selectedSegment) {
                        ForEach(0..<NewsContentType.allCases.count, id: \.self) {
                            Text(NewsContentType.allCases[$0].title)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 16)
                }
                switch NewsContentType.allCases[self.selectedSegment] {
                    case .all:
                        NewsView(initialLoading: $initialLoading, showSmthWentWrongAlert: $showSmthWentWrongAlert, showBlockAlert: $showBlockAlert, shouldBlockNews: $shouldBlockNews)
                    case .favorites:
                        FavoritesView(showBlockAlert: $showBlockAlert, shouldBlockNews: $shouldBlockNews)
                    case .blocked:
                        BlockedView(showUnblockAlert: $showUnblockAlert, shouldUnblockNews: $shouldUnblockNews)
                }
            }
            .background(.beige)
            .navigationTitle("News")
        }
        .overlay {
            self.loadingBlurView()
            self.smthWentWrongAlert()
            self.blockNewsAlert()
            self.unblockNewsAlert()
        }
    }
}

// MARK: - UI
// MARK: Alerts
private extension MainView {
    func loadingBlurView() -> some View {
        ZStack {
            if self.initialLoading {
                BlurView {
                    ProgressView()
                        .setDefaultStyle(color: .white)
                }
            }
        }.animation(.easeInOut(duration: 0.2), value: self.initialLoading)
    }
    
    func smthWentWrongAlert() -> some View {
        ZStack {
            if self.showSmthWentWrongAlert {
                BlurView {}
                    .alert("Something Went Wrong", isPresented: $showSmthWentWrongAlert) {
                        Button {
                            self.showSmthWentWrongAlert = false
                        } label: {
                            Text("OK")
                        }
                    }
            }
        }.animation(.easeInOut(duration: 0.2), value: self.initialLoading)
    }
    
    func blockNewsAlert() -> some View {
        ZStack {
            if self.showBlockAlert {
                BlurView {}
                    .alert("Do you want to block?", isPresented: $showBlockAlert) {
                        Button(role: .destructive) {
                            self.shouldBlockNews = true
                            self.showBlockAlert = false
                        } label: {
                            Text("Block")
                        }
                        Button(role: .cancel) {
                            self.showBlockAlert = false
                        } label: {
                            Text("Cancel")
                        }
                    } message: {
                        Text("Confirm to hide this news source")
                    }

            }
        }.animation(.easeInOut(duration: 0.2), value: self.showBlockAlert)
    }
    
    func unblockNewsAlert() -> some View {
        ZStack {
            if self.showUnblockAlert {
                BlurView {}
                    .alert("Do you want to unblock?", isPresented: $showUnblockAlert) {
                        Button(role: .destructive) {
                            self.shouldUnblockNews = true
                            self.showUnblockAlert = false
                        } label: {
                            Text("Unblock")
                        }
                        Button(role: .cancel) {
                            self.showUnblockAlert = false
                        } label: {
                            Text("Cancel")
                        }
                    } message: {
                        Text("Confirm to unblock this news source")
                    }
            }
        }.animation(.easeInOut(duration: 0.2), value: self.showUnblockAlert)
    }
}

#Preview {
    MainView()
}
