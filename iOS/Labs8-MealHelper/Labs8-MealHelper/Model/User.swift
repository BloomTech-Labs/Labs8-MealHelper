//
//  User.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var email: String
    var zip: Int
    var id: Int
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case zip
        case id
        case token
    }
}
