//
//  RealmNewsProtocol.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 18.05.25.
//

import Foundation

protocol RealmNewsProtocol: NewsProtocol {
    static func create(from news: any NewsProtocol) -> Self
}
