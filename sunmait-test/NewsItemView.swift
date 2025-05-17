//
//  NewsItemView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NewsItemView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.white)
            HStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(.beige)
                    Image(systemName: "newspaper.fill")
                        .foregroundStyle(.customBlue)
                        .frame(maxWidth: 24, maxHeight: 20)
                }
                .frame(width: 94, height: 86)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Street Art Festival Transforms City Walls")
                        .foregroundStyle(.customBlack)
                        .lineLimit(3)
                        .font(.system(size: 17, weight: .bold))
                    HStack {
                        Text("Art")
                            .foregroundStyle(.customGray)
                            .lineLimit(1)
                            .font(.system(size: 15, weight: .medium))
                        RoundedRectangle(cornerRadius: 2)
                            .foregroundStyle(.customGray)
                            .frame(width: 4, height: 4)
                        Text("Apr 17,2025")
                            .foregroundStyle(.customGray)
                            .lineLimit(1)
                            .font(.system(size: 15, weight: .medium))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                VStack {
                    Button {
                        print("Button did tap")
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.customGray)
                    }
                    .frame(width: 24, height: 24)
                    Spacer()
                }
                .padding(.leading, 16)
            }
            .padding(12)
        }
    }
}

#Preview {
    NewsView()
}
