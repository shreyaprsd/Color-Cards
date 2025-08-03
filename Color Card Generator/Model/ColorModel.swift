//
//  ColorModel.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class ColorModel {
    var hexCode: String
    var timeStamp: Date
    @Attribute(.unique) var id = UUID()
    init(hexCode: String, timeStamp: Date, id: UUID = UUID()) {
        self.hexCode = hexCode
        self.timeStamp = timeStamp
        self.id = id
    }
}
