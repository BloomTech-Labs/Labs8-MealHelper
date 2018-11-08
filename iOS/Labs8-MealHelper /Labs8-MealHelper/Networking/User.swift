//
//  User.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct User: Encodable {
    
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
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(String.self, forKey: .email)
//    }

}
