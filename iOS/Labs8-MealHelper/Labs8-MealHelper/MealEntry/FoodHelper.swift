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
    
}
