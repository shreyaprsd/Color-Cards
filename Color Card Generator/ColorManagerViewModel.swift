//
//  ViewModel.swift
//  Color Card Generator
//
//  Created by Shreya Prasad on 01/08/25.
//
import SwiftUI
import  Foundation

   class ColorManagerViewModel  {
    
    //1) create a state property that will hold a list of colors
    
    // 2) create an instance of the FireStoreDataManager class
    
    let firestoreDataManger = FirestoreDataManager()
    
    // 3) create a model context instance
    
    func addColor() {
        // Generate a random hex code
        
        // Construct a ColorModel object
        
        //First save the color to the model context instance
        
        // Next call
        //firestoreDataManger.add(color: <#T##ColorModel#>)
    }
    
    func addColor(colorModel: ColorModel) {
        //First delete the color from the model context instance
        
        // Next call
        //        firestoreDataManger.delete(id: colorModel.id)
    }
    
    func generateRandomHexCode() -> String {
        
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        
        let color = Color(red: red, green: green, blue: blue)
        let redInt = Int(red*255)
        let greenInt = Int(green*255)
        let blueInt = Int(blue*255)
        
        let hexString = String(format: "#%02X%02X%02X", redInt,greenInt,blueInt)
        return hexString
    }
    
  
   
}
