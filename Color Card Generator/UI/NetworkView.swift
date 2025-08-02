//
//  NetworkView.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 02/08/25.
//

import SwiftUI

struct NetworkView: View {
    var isConnected : Bool = false
    var body: some View {
        VStack(spacing: 10) {
            
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundStyle(isConnected ? .green : .red)
            Text(isConnected ? "Online" : "Offline")
                .foregroundStyle(isConnected ? .green : .red)
        }
    }
}

#Preview {
    NetworkView(isConnected: true)
        
}
