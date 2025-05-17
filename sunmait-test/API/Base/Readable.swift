//
//  Readable.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

protocol Readable {
    var readable: String { get }
}

extension [AnyHashable: Any]: Readable {
    var readable: String {
        self.compactMap({ "\($0.key): \($0.value)" }).joined(separator: "\n")
    }
}

extension Headers {
    var readable: String {
        self.compactMap({ "\($0.key): \($0.value)" }).joined(separator: "\n")
    }
}

extension Error {
    var readable: String {
        "ERROR: \(self.localizedDescription)"
    }
}

extension Data {
    var readable: String {
        "\(String(data: self, encoding: .utf8) ?? "ERROR: Can't render body (not utf8 encoded)")\n"
    }
}

