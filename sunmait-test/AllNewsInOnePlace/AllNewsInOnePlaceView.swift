//
//  AllNewsInOnePlaceView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct AllNewsInOnePlaceView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            VStack(spacing: 0) {
                Text("All News in One Place")
                    .foregroundStyle(.customBlack)
                    .font(.system(size: 17, weight: .bold))
                Text("Stay informed quickly\nand conveniently")
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(.customGray)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.top, 8)
                NavigationLink(destination: ContentAllNewsInOnePlaceView(), label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.customBlue)
                        Text("Go")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .light))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 16)
                    }
                })
                .padding(.top, 12)
            }
            .padding(.vertical, 12)
            .padding(.leading, 16)
            .padding(.trailing, 17)
        }
    }
}

#Preview {
    NewsView()
}
