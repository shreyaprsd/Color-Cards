import FirebaseFirestore
//
//  ColoRepository.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 03/08/25.
//
import Foundation
import SwiftData

class ColorRepository {
    //    1) check local db has colors
    //    2) if YES return colors[]
    //    3) if no check firebase has colors
    //    4) if FB has colors get from firebase and store it locally
    //    5) return to vM [colors}
    private let db = Firestore.firestore()
    private let collectionName = "cards"
    private var modelContext: ModelContext
    private var networkMonitor: NetworkMonitor = NetworkMonitor()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
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
    
    func addColorToFireStore(colorModel: ColorModel)  throws -> Result<String, Error> {
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
    
    func deleteColor( _ colorModel : ColorModel){
        //  first save this color to local db and
        // if connected to networksave color to firestore
    }
}
