//
//  FoodHelper.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 27.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct FoodHelper {
    
    enum Units: String {
        case kcal, grams = "g"
    }
    
    enum ServingTypes: String, CaseIterable {
        case cup, tablespoon, hundertGrams = "100g", ounce
    }
    
    enum MacroNutrients: Int {
        case energy = 208, carbs = 205, fat = 204, protein = 203
    }
    
    let macroNutrientIds = ["208", "205", "204", "203"] // Energy, carbs, fat, protein
    
    func convertHundertGrams(_ gm: Double, to unit: ServingTypes.RawValue) -> Double {
        switch unit {
        case ServingTypes.cup.rawValue:
            return gm * 1.5
        case ServingTypes.tablespoon.rawValue:
            return gm / 7.067
        case ServingTypes.ounce.rawValue:
            return gm / 3.527396195
        case ServingTypes.hundertGrams.rawValue:
            return gm
        default:
            return gm
        }
    }
    
    func udpateNutrients(_ nutrients: [Nutrient], to type: String, amount: Double = 1.0) -> [Nutrient] {
        return nutrients.map { (nutrient: Nutrient) -> Nutrient in
            var updatedNutrient = nutrient
            let convertedValue = FoodHelper().convertHundertGrams(nutrient.gm ?? 0, to: type) * amount
            updatedNutrient.value = String(format: "%.01f", convertedValue)
            return updatedNutrient
        }
    }
    
    func getMacroNutrients(from nutrients: [Nutrient]) -> MacroNutrient {
        var macroNutrients = MacroNutrient()
        
        for nutrient in nutrients {
            switch nutrient.nutrientId {
            case MacroNutrients.energy.rawValue:
                macroNutrients.energy = nutrient.value
            case MacroNutrients.carbs.rawValue:
                macroNutrients.carbs = nutrient.value
            case MacroNutrients.fat.rawValue:
                macroNutrients.fat = nutrient.value
            case MacroNutrients.protein.rawValue:
                macroNutrients.protein = nutrient.value
            default:
                continue
            }
        }
        
        return macroNutrients
    }
    
}
