//
//  ContentNavigationBlockView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct ContentNavigationBlockView: View {
    let navigationBlock: NavigationBlock
    var isSheetPresented: Binding<Bool>?
    
    var body: some View {
        ZStack {
            Color.beige.ignoresSafeArea()
            if self.navigationBlock.navigation != .push {
                self.modalTopButton()
            }
            VStack(spacing: 8) {
                switch self.navigationBlock.navigation {
                    case .push:
                        if let subtitle = self.navigationBlock.subtitle {
                            self.subtitle(subtitle)
                        }
                    case .modal:
                        if let titleSymbol = self.navigationBlock.titleSymbol {
                            Image(systemName: titleSymbol)
                                .foregroundStyle(.customBlue)
                                .font(.system(size: 40, weight: .light))
                        }
                        self.title()
                    case .fullScreen:
                        self.title()
                        if let subtitle = self.navigationBlock.subtitle {
                            self.subtitle(subtitle)
                        }
                }
            }
        }
        .presentationDragIndicator(self.navigationBlock.navigation.presentationDragIndicator)
        .navigationTitle(self.navigationBlock.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func modalTopButton() -> some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    isSheetPresented?.wrappedValue = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.customBlue)
                        .font(.system(size: 17, weight: .semibold))
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.top, 25)
        .padding(.leading, 16)
    }
    
    func title() -> some View {
        Text(self.navigationBlock.title)
            .foregroundStyle(.customBlack)
            .font(.system(size: 17, weight: .bold))
    }
    
    func subtitle(_ subtitle: String) -> some View {
        Text(subtitle)
            .multilineTextAlignment(.center)
            .foregroundStyle(.customGray)
            .font(.system(size: 15, weight: .medium))
    }
}
