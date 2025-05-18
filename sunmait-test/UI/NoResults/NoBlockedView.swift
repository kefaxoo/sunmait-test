//
//  NoBlockedView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import SwiftUI

struct NoBlockedView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "nosign")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.customBlue)
            Text("No Blocked News")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.customBlack)
        }
    }
}
