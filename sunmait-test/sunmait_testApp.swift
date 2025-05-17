//
//  sunmait_testApp.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 17.05.25.
//

import SwiftUI

@main
struct sunmait_testApp: App {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.customBlack]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.customBlack]
        
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.customBlack], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.customBlack], for: .selected)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
