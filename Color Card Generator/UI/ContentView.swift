//
//  ContentView.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    var colormanagerViewModel  = ColorManagerViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort:\ColorModel.timeStamp , order: .reverse) var colorModels : [ColorModel]
    // 1) create a ColorManagerViewModel instance
//   @State var colorModels : [ColorModel] = []
  
   
    var body: some View {
      
    
        VStack(spacing: 20){
            
                           Text("Color Cards 🎨")
                               .font(.largeTitle)
                              .padding()
                               .frame(maxWidth: .infinity,alignment: .leading)
            Button("Generate cards"){
                
                addColorToView()
            }.font(.title3)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .frame(maxWidth: 250)
            
           
                List {
                    // 1. Add a horizontally scrolling list of ColorCard()
                    
                    // 2. Add button that calls viewmodel.addColor()
                    ForEach(colorModels) { colorModel in
                        ColorCard(model: colorModel)
                    }
                    .onDelete(perform: deleteCards)
                }
            
            
        }
        .padding()
    }
    func addColorToView(){
        let newCard = ColorModel(hexCode: colormanagerViewModel.generateRandomHexCode(), timeStamp: .now)
        modelContext.insert(newCard)
        
        do {
            try modelContext.save()
        }catch {
            print("Error \(error.localizedDescription)")
        }
        
    }
    
    func deleteCards(_ indexSet : IndexSet){
        for i in indexSet {
            let card = colorModels[i]
            modelContext.delete(card)
        }
       
        
    }
  
}

#Preview {
    ContentView()
}
