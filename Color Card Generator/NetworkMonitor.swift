//
//  NetworkMonitor.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 03/08/25.
//
import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NWMonitor")
    @Published var isConnected: Bool = false

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                print(
                    "Network status changed: \(path.status == .satisfied ? "Connected" : "Disconnected")"
                )
            }
        }
        networkMonitor.start(queue: workerQueue)
    }

    deinit {
        networkMonitor.cancel()
    }
}
