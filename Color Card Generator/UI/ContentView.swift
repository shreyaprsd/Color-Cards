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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Color Cards 🎨")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button("Generate cards") {
                viewModel?.addColorCard()
            }
            .font(.title3)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .frame(maxWidth: 250)
            
            List {
                ForEach(colorModels) { colorModel in
                    ColorCard(model: colorModel)
                }
                .onDelete { indexSet in
                    viewModel?.deleteCards(at: indexSet, from: colorModels)
                }
            }
        }
        .padding()
        .onAppear {
            if viewModel == nil {
                viewModel = ColorCardViewModel(modelContext: modelContext)
            }
        }
    }
}
