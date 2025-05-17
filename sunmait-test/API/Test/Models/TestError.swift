//
//  TestError.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

struct TestErrorWrapper: Decodable {
    let error: TestError
}

struct TestError: Decodable {
    let statusCode: Int
    let reason: String
}

extension TestError: Error {
    var localizedDescription: String { self.reason }
}
