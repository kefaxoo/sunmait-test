//
//  URLRequest+Log.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

extension URLRequest {
    func printRequestLog() {
        let urlString = self.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let method = self.httpMethod ?? ""
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        let host = components?.host ?? ""
        
        var requestLog = "\n----- REQUEST ----->\n"
        requestLog += "\(urlString)\n\n"
        requestLog += "\(method) \(path) \(query.isEmpty ? "" : "?\(query)") HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        requestLog += self.allHTTPHeaderFields?.readable ?? ""
        requestLog += "cURL: \n\(self.curl)"
        requestLog += "\n------------------->\n"
        #if DEBUG
        print(requestLog)
        #endif
    }
    
    var curl: String {
        let newLine = "\\\n"
        let method = "--request " + "\(self.httpMethod ?? "GET") \(newLine)"
        let url = "--url " + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        var curl = "curl "
        var header = ""
        var data = ""
        
        if let headers = self.allHTTPHeaderFields, headers.keys.count > 0 {
            headers.forEach { key, value in
                header += "--header " + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let body = self.httpBody,
            let bodyString = String(data: body, encoding: .utf8),
            !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        curl += method + url + header + data
        return curl
    }
}
