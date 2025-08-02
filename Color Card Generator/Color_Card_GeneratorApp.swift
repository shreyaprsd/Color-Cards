//
//  Color_Card_GeneratorApp.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//

import SwiftUI
import SwiftData

@main
struct Color_Card_GeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ColorModel.self])
        }
    }
}
