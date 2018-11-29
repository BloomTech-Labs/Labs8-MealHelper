//
//  Alarm.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 28/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Alarm: Codable {
    
    var id: Int
    var userId: Int
    var note: String
    var time: String
    var timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case note = "label"
        case time = "alarm"
        case timestamp
    }
}
