//
//  Food.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

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

struct Recipe: Codable {
    
    init(name: String, calories: Int, servings: Int, ingredients: [Ingredient] = [], userId: Int?, mealId: Int?) {
        self.name = name
        self.calories = calories
        self.ingredients = ingredients
        self.userId = userId
    }
    
    var identifier: Int?
    var name: String?
    var calories: Int?
    var servings: Int?
    var mealId: Int?
    var userId: Int?
    var ingredientId: Int?
    var ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case calories
        case servings
        case mealId = "meal_id"
        case userId = "user_id"
        case ingredientId = "ingredients_id"
    }
    
}

struct Ingredient: Codable {
    
    var identifier: Int?
    var name: String?
    var nbdId: Int?
    var userId: Int?
    var nutrientIds: [Int]?
    var nutrients: [Nutrient]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case nbdId = "nbd_id"
        case userId = "user_id"
        case nutrientIds = "nutrients_id"
    }
    
}

struct Nutrient: Codable {
    
    var identifier: String? // usda nutrient id
    var name: String?
    var unit: String?
    var value: String?
    var gm: Double? // The 100 gram equivalent value for the nutrient
    
    enum CodingKeys: String, CodingKey {
        case identifier = "nutrient_id"
        case name = "nutrient"
        case unit
        case value
        case gm
    }
    
}
