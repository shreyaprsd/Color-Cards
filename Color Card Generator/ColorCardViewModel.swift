//
//  ViewModel.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//
import SwiftUI
import SwiftData
import Network

@Observable
class ColorCardViewModel {
    private var modelContext: ModelContext
    
    // Network monitoring properties
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NWMonitor")
    var isConnected = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // Initialize network status first
        isConnected = false
        setupNetworkMonitoring()
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                print("Network status changed: \(path.status == .satisfied ? "Connected" : "Disconnected")")
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    func stopNetworkMonitoring() {
        networkMonitor.cancel()
    }
    
    // MARK: - Color Card Management
    func addColorCard() {
        let newCard = ColorModel(
            hexCode: generateRandomHexCode(),
            timeStamp: .now
        )
        modelContext.insert(newCard)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving color card: \(error.localizedDescription)")
        }
    }
    
    func deleteCards(at indexSet: IndexSet, from colorModels: [ColorModel]) {
        for index in indexSet {
            let card = colorModels[index]
            modelContext.delete(card)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting color cards: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Helper Methods
    private func generateRandomHexCode() -> String {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    deinit {
        networkMonitor.cancel()
    }
}
