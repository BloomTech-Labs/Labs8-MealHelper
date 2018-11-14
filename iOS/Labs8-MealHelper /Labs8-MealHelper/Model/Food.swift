//
//  Food.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 14.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Meal: Encodable {
    
    var identifier: Int?
    var mealTime: String?
    var experience: String?
    var date: String?
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case mealTime
        case experience
        case date
        case userId = "user_id"
    }
    
}

struct Ingredient: Encodable {
    
    var identifier: Int?
    var name: String?
    var nbdId: Int?
    var userId: Int?
    var nutrientIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case nbdId = "nbd_id"
        case userId = "user_id"
        case nutrientIds = "nutrients_id"
    }
    
}

struct Nutrient: Encodable {
    
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
