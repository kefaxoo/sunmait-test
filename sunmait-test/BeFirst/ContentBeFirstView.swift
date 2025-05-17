//
//  ContentBeFirstView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct ContentBeFirstView: View {
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 0) {
                    Button {
                        self.isSheetPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.customBlue)
                            .font(.system(size: 17, weight: .semibold))
                    }
                    Spacer()
                }
                Spacer()
            }
            VStack(spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .foregroundStyle(.customBlue)
                    .font(.system(size: 40, weight: .light))
                Text("Be First to Know What Matters")
                    .foregroundStyle(.customBlack)
                    .font(.system(size: 17, weight: .bold))
            }
        }
        .padding(.top, 25)
        .padding(.leading, 16)
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    NewsView()
}
