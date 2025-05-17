//
//  BaseAPIProtocol.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

protocol BaseAPIProtocol {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var body: Data? { get }
    
    var request: URLRequest? { get }
}


extension BaseAPIProtocol {
    var request: URLRequest? {
        var urlComponents = URLComponents(string: self.baseUrl + self.path)
        urlComponents?.addParameters(self.parameters)
        
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        self.headers?.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        
        if let body {
            request.httpBody = body
        }
        
        return request
    }
    
    var body: Data? { nil }
}
