//
//  TestAPIService.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation
import Combine

final class TestAPIService: BaseAPIService<TestAPI> {
    static let shared = TestAPIService()
    
    func navigationBlocks(completionHandler: @escaping((ResponseResult<[NavigationBlock]>) -> Void)) {
        self.dataTask(with: .navigationBlocks) { result in
            switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        switch response.data.parse(to: NavigationBlockResults.self) {
                            case .success(let results):
                                completionHandler(.success(results.results))
                            case .failure(let error):
                                completionHandler(.failure(error))
                        }
                    } else if (400..<500).contains(response.statusCode) {
                        completionHandler(.failure(self.parseError(from: response)))
                    } else {
                        completionHandler(.failure(NetworkError.networkError(statusCode: response.statusCode)))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    func news(page: Int = 1, completionHandler: @escaping((ResponseResult<NewsResponseInfo>) -> Void)) {
        self.dataTask(with: .news(page: page)) { result in
            switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        switch response.data.parse(to: NewsResponseWrapper.self) {
                            case .success(let wrapper):
                                completionHandler(.success(wrapper.response))
                            case .failure(let error):
                                completionHandler(.failure(error))
                        }
                    } else if (400..<500).contains(response.statusCode) {
                        completionHandler(.failure(self.parseError(from: response)))
                    } else {
                        completionHandler(.failure(NetworkError.networkError(statusCode: response.statusCode)))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}

// MARK: - Parse Error
private extension TestAPIService {
    func parseError(from response: ResponseSuccess) -> Error {
        switch response.data.parse(to: TestErrorWrapper.self) {
            case .success(let wrapper):
                wrapper.error
            case .failure(let error):
                error
        }
    }
}
