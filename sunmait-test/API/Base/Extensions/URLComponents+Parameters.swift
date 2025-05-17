//
//  URLComponents+Parameters.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

extension URLComponents {
    mutating func addParameters(_ parameters: Parameters?) {
        self.queryItems = parameters?.compactMap {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
    }
}
