//
//  NetworkManager.swift
//  sunmait-test
//
//  Created by Bahdan Piatrouski on 19.05.25.
//

import Foundation
import Network

final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private lazy var monitor = NWPathMonitor()
    @Published private(set) var isConnected: Bool = true
    
    func startMonitoring() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                var newState = path.status == .satisfied
                guard self?.isConnected != newState else { return }
                
                self?.isConnected = newState
            }
        }
        
        self.monitor.start(queue: DispatchQueue(label: "sunmait-test-network-queue"))
    }
}
