//
//  ReadLearnShareView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct ReadLearnShareView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            VStack(spacing: 0) {
                Text("Read. Learn. Share.")
                    .foregroundStyle(.customBlack)
                    .font(.system(size: 17, weight: .bold))
                Text("Only fresh and verified news")
                    .foregroundStyle(.customGray)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.top, 8)
                NavigationLink(destination: ContentReadLearnShareView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.customBlue)
                        Text("Try Premium")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .bold))
                            .padding(.vertical, 12)
                    }
                }
                .padding(.top, 12)
            }
            .padding(.vertical, 21)
            .padding(.leading, 16)
            .padding(.trailing, 17)
        }
    }
}

#Preview {
    NewsView()
}
