//
//  NoFavoriteView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import SwiftUI

struct NoFavoriteView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.circle.fill")
                .foregroundStyle(.customBlue)
                .font(.system(size: 40, weight: .light))
            Text("No Favorite News")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.customBlack)
        }
    }
}
