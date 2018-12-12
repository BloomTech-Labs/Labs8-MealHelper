//
//  Note.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 12.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Note: Codable {
    
    var id: Int
    var mealId: Int
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case mealId = "meal_id"
        case text = "notebody"
    }
}
