//
//  Food.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

// MARK: - MealHelper

struct Meal: Codable {
    
    var identifier: Int
    var name: String
    var mealTime: String
    var experience: String?
    var temp: Double
    var date: String
    var userId: Int?
    var humidity: Double?
    var pressure: Double?
    var notes: String?
    var servings: Int?
    var recipeId: Int?
    var recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case mealTime
        case experience
        case temp
        case date
        case userId = "user_id"
        case humidity
        case pressure
        case notes
        case servings
        case recipeId = "recipe_id"
    }
}

struct Recipe: Codable, Equatable {
    
    var identifier: Int
    var name: String
    var calories: String
    var servings: Int
    var userId: Int?
    var ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case calories
        case servings
        case userId = "user_id"
    }
}

func ==(lhs: Recipe, rhs: Recipe) -> Bool {
    return lhs.identifier == rhs.identifier
}

struct Ingredient: Codable, Equatable {
    
    init(name: String, nbdId: Int) {
        self.name = name
        self.nbdId = nbdId
    }
    
    var identifier: Int?
    var name: String
    var nbdId: Int?
    var userId: Int?
    var nutrientIds: [Int]?
    var recipeId: Int?
    var nutrients: [Nutrient]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case nbdId = "ndb_id"
        case userId = "user_id"
        case nutrientIds = "nutrients_id"
        case recipeId = "recipe_id"
    }
}

func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
    return lhs.nbdId == rhs.nbdId
}

struct Nutrient: Codable {
    
    var identifier: String // usda nutrient id
    var name: String
    var unit: String
    var value: String
    var gm: Double // The 100 gram equivalent value for the nutrient
    var ingredientId: Int?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "nutrient_id"
        case name = "nutrient"
        case unit
        case value
        case gm
        case ingredientId = "ingredients_id"
    }
}

struct MacroNutrient {
    
    var energy: String?
    var carbs: String?
    var fat: String?
    var protein: String?
    
}

// MARK: - USDA

struct UsdaIngredients: Codable {
    
    var list: Item
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    struct Item: Codable {
        var item: [UsdaIngredient]
        
        enum CodingKeys: String, CodingKey {
            case item
        }
        
        struct UsdaIngredient: Codable {
            var ndbId: String
            var name: String
            var manufacturer: String?
            
            enum CodingKeys: String, CodingKey {
                case ndbId = "ndbno"
                case name
                case manufacturer = "manu"
            }
        }
    }
}

struct UsdaNutrient: Codable {
    
    var report: Report
    
    enum CodingKeys: String, CodingKey {
        case report
    }
    
    struct Report: Codable {
        var foods: [Food]
        
        enum FoodCodingKeys: String, CodingKey {
            case foods
        }
        
        struct Food: Codable {
            var ndbno: String?
            var name: String?
            var weight: Double?
            var measure: String?
            var nutrients: [Nutrient]
            
            enum CodingKeys: String, CodingKey {
                case ndbno
                case name
                case measure
                case nutrients
            }
        }
    }
}

// TODO: To be deleted. Used as temporary response type after posting nutrients
struct TempType: Codable {
    
    var command: String
    
    enum CodingKeys: String, CodingKey {
        case command
    }
}
