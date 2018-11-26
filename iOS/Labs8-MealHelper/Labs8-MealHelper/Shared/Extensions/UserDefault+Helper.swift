//
//  UserDefault+Helper.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 18.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case userId
    }
    
    func setIsLoggedIn(value: Bool, userId: Int) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        set(userId, forKey: UserDefaultsKeys.userId.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func loggedInUserId() -> Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
}
