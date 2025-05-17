//
//  BaseAPIService.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

class BaseAPIService<T> where T: BaseAPIProtocol {
    typealias ResponseSuccess = (data: Data, statusCode: Int)
    typealias DataResult = Result<ResponseSuccess, Error>
    typealias ResponseResult<Response: Decodable> = Result<Response, Error>
    
    public let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension BaseAPIService {
    @discardableResult public func dataTask(
        with endpoint: T?,
        responseCompletion: @escaping((DataResult) -> Void)
    ) -> URLSessionTask? {
        guard let request = endpoint?.request else { return nil }
        
        request.printRequestLog()
        let task = self.urlSession.dataTask(with: request) { data, response, error in
            response?.printLog(data: data, error: error)
            
            if let error {
                DispatchQueue.main.async {
                    responseCompletion(.failure(error))
                }
                
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                responseCompletion(.failure(NetworkError.invalidResponse))
                return
            }
            
            DispatchQueue.main.async {
                if let data {
                    responseCompletion(.success((data, httpUrlResponse.statusCode)))
                } else {
                    responseCompletion(.failure(NetworkError.invalidResponse))
                }
            }
        }
        
        task.resume()
        return task
    }
}
