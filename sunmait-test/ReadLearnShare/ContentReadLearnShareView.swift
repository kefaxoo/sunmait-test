//
//  ContentReadLearnShareView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct ContentReadLearnShareView: View {
    @Environment(\.dismiss) private var pop
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Read. Learn. Share.")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.customBlack)
            Text("Only fresh and verified news")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.customGray)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.pop()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.customBlue)
                        .font(.system(size: 17, weight: .bold))
                }

            }
        }
    }
}

#Preview {
    NewsView()
}
