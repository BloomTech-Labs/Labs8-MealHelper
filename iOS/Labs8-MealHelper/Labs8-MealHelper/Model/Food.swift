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
    
    init(mealTime: String, experience: String, date: String, userId: Int) {
        self.mealTime = mealTime
        self.experience = experience
        self.date = date
        self.userId = userId
    }
    
    var identifier: Int?
    var mealTime: String?
    var experience: String?
    var date: String?
    var userId: Int?
    var recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case mealTime
        case experience
        case date
        case userId = "user_id"
    }
}

struct Recipe: Codable, Equatable {
    
    init(name: String, calories: String, servings: Int, ingredients: [Ingredient] = [], userId: Int?, mealId: Int?) {
        self.name = name
        self.calories = calories
        self.servings = servings
        self.ingredients = ingredients
        self.userId = userId
    }
    
    var identifier: Int?
    var name: String?
    var calories: String?
    var servings: Int?
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
    
    init(name: String, nbdId: String) {
        self.name = name
        self.nbdId = nbdId
    }
    
    var identifier: Int?
    var name: String?
    var nbdId: String?
    var userId: Int?
    var nutrientIds: [Int]?
    var recipeId: Int?
    var nutrients: [Nutrient]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case nbdId = "nbd_id"
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
    
    enum CodingKeys: String, CodingKey {
        case identifier = "nutrient_id"
        case name = "nutrient"
        case unit
        case value
        case gm
    }
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
