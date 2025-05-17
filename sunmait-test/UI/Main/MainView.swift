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
    
    // MARK: Initial
    @State private var initialLoading = true
    
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
                        NewNewsView(initialLoading: $initialLoading, showSmthWentWrongAlert: $showSmthWentWrongAlert)
                    default:
                        Text("")
                }
            }
            .background(.beige)
            .navigationTitle("News")
        }
        .overlay {
            self.loadingBlurView()
        }
    }
}

// MARK: - UI
private extension MainView {
    func defaultProgressView(color: Color = .customGray) -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(color)
            .scaleEffect(1.5)
            .padding(.vertical, 8)
    }
}

// MARK: Alerts
private extension MainView {
    func loadingBlurView() -> some View {
        ZStack {
            if self.initialLoading {
                BlurView {
                    self.defaultProgressView(color: .white)
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
}

#Preview {
    MainView()
}
