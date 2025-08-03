//
//  ViewModel.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//
import SwiftUI
import SwiftData
import Network
import FirebaseFirestore

@Observable
class ColorCardViewModel {
    private var modelContext: ModelContext
    
    private let db = Firestore.firestore()
    private let collectionName = "cards"
    private  var colorRepository : ColorRepository
    init(modelContext: ModelContext , colorRepository: ColorRepository) {
        self.modelContext = modelContext
        self.colorRepository = colorRepository
        loadInitialData()
        
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        Task {
            do {
                try await colorRepository.fetchDataFromFireStore()
            } catch {
                print("Error loading initial data: \(error.localizedDescription)")
            }
        }
    }
    
    func addColorCard()  {
        let newCard = ColorModel(
            hexCode: generateRandomHexCode(),
            timeStamp: .now
        )
        colorRepository.addColor(newCard)
        
    }
    
    
    
    func deleteCards(at indexSet: IndexSet, from colorModels: [ColorModel]) async {
        for index in indexSet {
            let card = colorModels[index]
               await colorRepository.deleteCards(at: indexSet, from: colorModels)
                print("Successfully deleted card )")
            
        }
    }
    
    private func generateRandomHexCode() -> String {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    
    

    
    
    
}


