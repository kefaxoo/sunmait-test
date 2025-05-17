//
//  ProgressView+Custom.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

extension ProgressView {
    func setDefaultStyle(color: Color = .customGray) -> some View {
        self
            .progressViewStyle(.circular)
            .tint(color)
            .scaleEffect(1.5)
            .padding(.vertical, 8)
    }
}
