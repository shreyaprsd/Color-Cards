
//
//  ColoRepository.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 03/08/25.
//
import FirebaseFirestore
import Combine
import Foundation
import SwiftData

class ColorRepository {
    private let db = Firestore.firestore()
    private let collectionName = "cards"
    private var modelContext: ModelContext
    private var networkMonitor: NetworkMonitor = NetworkMonitor()
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
            self.modelContext = modelContext
            setupNetworkObserver()
        }
        
        private func setupNetworkObserver() {
            networkMonitor.$isConnected
                .sink { [weak self] isConnected in
                    if isConnected {
                        Task {
                            do {
                                try await self?.fetchDataFromFireStore()
                            } catch {
                                print("Error fetching data when network became available: \(error)")
                            }
                        }
                    }
                }
                .store(in: &cancellables)
        }
    
    func addColor( _ colorModel : ColorModel){
        do {
            modelContext.insert(colorModel)
            try modelContext.save()
            
            if networkMonitor.isConnected {
                let result = try addColorToFireStore(colorModel: colorModel)
                switch result {
                case .success(let documentID):
                    print("Successfully synced card with ID: \(documentID)")
                case .failure(let error):
                    print("Failed to sync to Firestore: \(error.localizedDescription)")
                    
                }
            }
        } catch {
            print("Error saving color card locally: \(error.localizedDescription)")
        }
        
    }
    
    private func addColorToFireStore(colorModel: ColorModel)  throws -> Result<String, Error> {
        let remoteModel = RemoteColorModel(model: colorModel)
        
        do {
            let ref = try  db.collection(collectionName).addDocument(from: remoteModel)
            print("Document added with ID: \(ref.documentID)")
            return .success(ref.documentID)
        } catch {
            print("Error adding document to Firestore: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func fetchDataFromFireStore() async throws {
        if networkMonitor.isConnected {
            let snapshot = try await db.collection(collectionName).getDocuments()
            do {
                try snapshot.documents.forEach { document in
                    let firestoreColor = try document.data(as: RemoteColorModel.self)
                    
                    let colorModel = firestoreColor.toColorModel()
                    modelContext.insert(colorModel)
                    try modelContext.save()
                    
                }
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    func deleteCards(at indexSet: IndexSet, from colorModels: [ColorModel]) async {
        for index in indexSet {
            let card = colorModels[index]
            
            do {
                if networkMonitor.isConnected{
                    // Delete from Firestore first
                    try await deleteColorFromFireStore(colorModel: card)
                    // Then delete locally
                    modelContext.delete(card)
                    try modelContext.save()
                    print("Successfully deleted card with hex: \(card.hexCode)")
                    
                }
            } catch {
                print("Error deleting card with hex \(card.hexCode): \(error.localizedDescription)")
                // You might want to show an alert to the user here
            }
        }
    }
    
    private func deleteColorFromFireStore(colorModel: ColorModel) async throws {
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


