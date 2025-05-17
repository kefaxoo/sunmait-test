//
//  BlurView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct BlurView<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            Color.black.opacity(0.5)
            self.content
        }
        .ignoresSafeArea()
    }
}
