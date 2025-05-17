//
//  NewsView.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NewsView: View {
    @State private var selectedSegment = 0
    private var segments = ["All", "Favorites", "Blocked"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select a segment", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(self.segments[index])
                    }
                }
                .pickerStyle(.segmented)
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(0...20, id: \.self) { i in
                            if i % 3 == 2 {
                                if (i / 3) % 3 == 0 {
                                   AllNewsInOnePlaceView()
                                } else if (i / 3) % 3 == 1 {
                                    BeFirstView()
                                } else if (i / 3) % 3 == 2 {
                                    ReadLearnShareView()
                                }
                            } else {
                                NewsItemView()
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .navigationTitle("News")
            .background(.beige)
        }
    }
}

#Preview {
    NewsView()
}
