//
//  ContentView.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ColorModel.timeStamp, order: .reverse) var colorModels: [ColorModel]
    @State private var viewModel: ColorCardViewModel?
    @ObservedObject private var networkMonitor = NetworkMonitor()
    var body: some View {
        VStack(spacing: 20) {
            Text("Color Cards 🎨")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Button("Generate cards") {
                    viewModel?.addColorCard()
                }
                .font(.title3)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .frame(maxWidth: 250)
                
                NetworkView(isConnected: networkMonitor.isConnected ?? false)
            }
            List {
                ForEach(colorModels) { colorModel in
                    ColorCard(model: colorModel)
                }
                .onDelete { indexSet in
                    Task{
                        await  viewModel?.deleteCards(at: indexSet, from: colorModels)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if viewModel == nil {
                let colorRepository = ColorRepository(modelContext: modelContext) // or howevoer you create it
                viewModel = ColorCardViewModel(
                    modelContext: modelContext,
                    colorRepository: colorRepository
                )
            }
        }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ColorModel.self, inMemory: true)
}
