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
    
    func convertHundertGrams(_ gm: Double, to unit: ServingTypes) -> Double {
        switch unit {
        case .cup:
            return gm * 1.5
        case .tablespoon:
            return gm / 7.067
        case .ounce:
            return gm / 3.527396195
        case .hundertGrams:
            return gm
        }
    }
    
}
