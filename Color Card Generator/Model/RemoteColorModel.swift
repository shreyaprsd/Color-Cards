//
//  RemoteColorModel.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 02/08/25.
//


// 1) Create a RemoteColorModel that represents the data type in which Firestore will store the color dats

// 2) implement the Codable protocol

// id : String
// hexcode: String
// timeStamp: timestamp

import Foundation
import SwiftUI
import FirebaseCore

struct RemoteColorModel {
    var id : String
    var hexCode : String
    var timeStamp : Timestamp
    
    init(model: ColorModel) {
        id = model.id.uuidString
        hexCode = model.hexCode
        timeStamp = Timestamp(date: model.timeStamp)
    }
    
    
    func toColorModel() -> ColorModel {
        return ColorModel(hexCode: self.hexCode, timeStamp: self.timeStamp.dateValue(), id: UUID(uuidString: self.id) ?? UUID())
    }
    
    func fromColorModel(_ model: ColorModel) -> RemoteColorModel {
        
    }
    
    
}
