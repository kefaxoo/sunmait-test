//
//  ContentAllNewsInOnePlaceView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct ContentAllNewsInOnePlaceView: View {
    var body: some View {
        ZStack {
            Color.beige.ignoresSafeArea()
            VStack {
                Text("Stay informed quickly\nand conveniently")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.customGray)
                    .font(.system(size: 15, weight: .medium))
            }
        }
        .navigationTitle("All News in One Place")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NewsView()
}
