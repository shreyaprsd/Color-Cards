//
//  ViewModel.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//
import SwiftData
import Foundation

@Observable
class ColorManagerViewModel  {
    
    private var modelContext: ModelContext
    
    // The ViewModel now holds and manages the data
    @Query(sort: \ColorModel.timeStamp, order: .reverse)
    var colorModels: [ColorModel]
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // Initialize the query with the context
        self._colorModels = Query(sort: \ColorModel.timeStamp, order: .reverse)
    }
    
    func addColorCard() {
        // Generate random hex code directly in ViewModel
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
    
    func deleteCards(at indexSet: IndexSet) {
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
    
    // Private helper function to generate random hex codes
    private func generateRandomHexCode() -> String {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}
