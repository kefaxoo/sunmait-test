//
//  NavigationBlock.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

struct NavigationBlockResults: Decodable {
    let results: [NavigationBlock]
}

struct NavigationBlock: Decodable {
    let id: Int
    let titleSymbol: String?
    let title: String
    let subtitle: String?
    let buttonTitle: String
    let buttonSymbol: String?
    let navigation: NavigationBlockNavigationType
    
    enum CodingKeys: String, CodingKey {
        case id
        case titleSymbol = "title_symbol"
        case title
        case subtitle
        case buttonTitle = "button_title"
        case buttonSymbol = "button_symbol"
        case navigation
    }
}

enum NavigationBlockNavigationType: String, Decodable {
    case push
    case modal
    case fullScreen = "full_screen"
    
    var presentationDragIndicator: Visibility {
        self == .modal ? .visible : .hidden
    }
}
