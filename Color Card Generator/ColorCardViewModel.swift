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
                _ = try await fetchDataFromFireStore()
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
            
            do {
                // Delete from Firestore first
                try await deleteColorFromFireStore(colorModel: card)
                // Then delete locally
                modelContext.delete(card)
                try modelContext.save()
                print("Successfully deleted card with hex: \(card.hexCode)")
            } catch {
                print("Error deleting card with hex \(card.hexCode): \(error.localizedDescription)")
                // You might want to show an alert to the user here
            }
        }
    }
    
    private func generateRandomHexCode() -> String {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    
    
    func fetchDataFromFireStore() async throws -> [ColorModel] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        do {
            return try snapshot.documents.compactMap { document in
                let firestoreColor = try document.data(as: RemoteColorModel.self)
                
                let colorModel = firestoreColor.toColorModel()
                return colorModel
                
            }
        } catch {
            print("Error getting documents: \(error)")
            return []
        }
    }
    
    
    func deleteColorFromFireStore(colorModel: ColorModel) async throws {
        let remoteModel = RemoteColorModel(model: colorModel)
        
        let querySnapshot = try await db.collection(collectionName)
            .whereField("id", isEqualTo: remoteModel.id)
            .getDocuments()
        
        // Delete all matching documents (should typically be just one)
        for document in querySnapshot.documents {
            try await document.reference.delete()
            print("Document deleted with ID: \(document.documentID)")
        }
        
        if querySnapshot.documents.isEmpty {
            print("Warning: No document found with id: \(remoteModel.id)")
        }
    }
}


