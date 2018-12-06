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
        case zipCode
    }
    
    func setIsLoggedIn(value: Bool, userId: Int) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        set(userId, forKey: UserDefaultsKeys.userId.rawValue)
        //set(zipCode, forKey: UserDefaultsKeys.zipCode.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func loggedInUserId() -> Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
//    func loggedInZipCode() -> Int {
//        return integer(forKey: UserDefaultsKeys.zipCode.rawValue)
//    }
    
}
