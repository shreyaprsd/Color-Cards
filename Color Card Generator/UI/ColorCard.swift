//
//  ColorCard.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//

import SwiftUI

struct ColorCard: View {
    var model : ColorModel
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color( hex:model.hexCode))
                .frame(width: 100,  height: 100)
                .padding()
            VStack {
                Text(model.timeStamp , style: .date)
                Text(model.timeStamp , style: .time)
            }
        }
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (
                255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
            )
        case 6:  // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (a, r, g, b) = (
                int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
            )
        default:
            // Default to red for invalid hex
            (a, r, g, b) = (255, 0, 0, 0)
     
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ColorCard(model: ColorModel(hexCode: "#808080", timeStamp: .now))
}
