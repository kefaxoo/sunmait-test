//
//  NetworkError.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case networkError(statusCode: Int)
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
            case .invalidRequest:
                "Invalid Request"
            case .invalidResponse:
                "Invalid Response"
            case .networkError(let statusCode):
                "Network Error (\(statusCode))"
        }
    }
}
