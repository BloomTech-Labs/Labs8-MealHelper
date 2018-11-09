//
//  User.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct User: Encodable {
    
    init(email: String, password: String, zip: Int, healthCondition: String) {
        self.email = email
        self.password = password
        self.zip = zip
        self.healthCondition = healthCondition
    }
    
    var email: String
    var password: String
    var zip: Int
    var healthCondition: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case zip
        case healthCondition
    }
}
