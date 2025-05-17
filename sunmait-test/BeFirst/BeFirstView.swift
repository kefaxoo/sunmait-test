//
//  BeFirstView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct BeFirstView: View {
    @State private var isContentPresented = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            VStack(spacing: 0) {
                Image(systemName: "star.circle.fill")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.customBlue)
                Text("Be First to Know What Matters")
                    .foregroundStyle(.customBlack)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.vertical, 8)
                Button {
                    self.isContentPresented = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.customBlue)
                        Text("Start Reading")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .bold))
                            .padding(.vertical, 12)
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 16)
                    }
                }

            }
            .padding(.vertical, 18)
            .padding(.leading, 16)
            .padding(.trailing, 17)
            .sheet(isPresented: $isContentPresented) {
                ContentBeFirstView(isSheetPresented: $isContentPresented)
            }
        }
    }
}

#Preview {
    NewsView()
}
