//
//  NavigationBlockView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

fileprivate struct NavigationBlockButtonView: View {
    let navigationBlock: NavigationBlock
    
    @State private var isSheetPresented = false
    @State private var isFullScreenSheetPresented = false
    
    var body: some View {
        switch self.navigationBlock.navigation {
            case .push:
                NavigationLink(destination: ContentNavigationBlockView(navigationBlock: self.navigationBlock)) {
                    self.button()
                }
            case .modal:
                Button {
                    self.isSheetPresented = true
                } label: {
                    self.button()
                }
                .sheet(isPresented: $isSheetPresented) {
                    ContentNavigationBlockView(navigationBlock: self.navigationBlock, isSheetPresented: $isSheetPresented)
                }
            case .fullScreen:
                Button {
                    self.isFullScreenSheetPresented = true
                } label: {
                    self.button()
                }
                .fullScreenCover(isPresented: $isFullScreenSheetPresented) {
                    ContentNavigationBlockView(navigationBlock: self.navigationBlock, isSheetPresented: $isFullScreenSheetPresented)
                }
        }
    }
    
    func button() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(.customBlue)
            self.buttonText()
            if let buttonSymbol = self.navigationBlock.buttonSymbol {
                self.buttonImage(name: buttonSymbol)
            }
        }
    }
    
    func buttonText() -> some View {
        Text(self.navigationBlock.buttonTitle)
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(.white)
            .padding(.vertical, 12)
    }
    
    func buttonImage(name: String) -> some View {
        HStack {
            Spacer()
            Image(systemName: name)
                .font(.system(size: 20, weight: .light))
                .foregroundStyle(.white)
        }
        .padding(.trailing, 16)
    }
}

struct NavigationBlockView: View {
    let navigationBlock: NavigationBlock
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            VStack(spacing: 0) {
                if let titleSymbol = self.navigationBlock.titleSymbol {
                    Image(systemName: titleSymbol)
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(.customBlue)
                        .padding(.bottom, 8)
                }
                Text(self.navigationBlock.title)
                    .foregroundStyle(.customBlack)
                    .font(.system(size: 17, weight: .bold))
                if let subtitle = self.navigationBlock.subtitle {
                    Text(subtitle)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundStyle(.customGray)
                        .font(.system(size: 15, weight: .medium))
                        .padding(.top, 8)
                }
                NavigationBlockButtonView(navigationBlock: self.navigationBlock)
                    .padding(.top, 12)
            }
            .padding(.vertical, 12)
            .padding(.leading, 16)
            .padding(.trailing, 17)
        }
        .padding(.horizontal, 16)
    }
}
