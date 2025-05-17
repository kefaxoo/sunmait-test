//
//  URLResponse+Log.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

extension URLResponse {
    func printLog(data: Data?, error: Error?) {
        let urlString = self.url?.absoluteString ?? ""
        let components = URLComponents(string: urlString)
        
        let path = components?.path ?? ""
        let query = components?.query ?? ""
        
        var responseLog = "\n<----- RESPONSE -----\n"
        responseLog += "\(urlString)\n\n"
        var statusCodeString = ""
        if let statusCode = (self as? HTTPURLResponse)?.statusCode {
            statusCodeString = "\(statusCode)"
        }
        
        responseLog += "HTTP \(statusCodeString) \(path)\(query.isEmpty ? "" : "?\(query)")\n"
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        
        responseLog += (self as? HTTPURLResponse)?.allHeaderFields.readable ?? ""
        responseLog += data?.readable ?? ""
        responseLog += error?.readable ?? ""
        responseLog += "\n<-------------------\n"
        #if DEBUG
        print(responseLog)
        #endif
    }
}
