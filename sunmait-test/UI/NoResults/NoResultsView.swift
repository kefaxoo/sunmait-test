//
//  NoResultsView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NoResultsView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(.customBlue)
                Text("No Results")
                    .font(.system(size: 17, weight: .bold))
                    .padding(.top, 8)
                    .foregroundStyle(.customBlack)
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.customBlue)
                        Text("Refresh")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .bold))
                            .padding(.vertical, 12)
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 16)
                    }
                }
                .frame(maxHeight: 44)
                .padding(.top, 12)
                .padding(.leading, 17)
                .padding(.trailing, 16)
            }
        }
    }
}
