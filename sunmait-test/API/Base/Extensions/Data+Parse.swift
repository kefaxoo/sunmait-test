//
//  Data+Parse.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import Foundation

extension Data {
    func parse<T>(to type: T.Type) -> Result<T, Error> where T: Decodable {
        do {
            return Result.success(try JSONDecoder().decode(type, from: self))
        } catch {
            return Result.failure(error)
        }
    }
}
