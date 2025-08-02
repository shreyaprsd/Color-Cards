//
//  Color_Card_GeneratorApp.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//

import SwiftUI
import SwiftData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main
struct Color_Card_GeneratorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ColorModel.self])
                
        }
    }
}
