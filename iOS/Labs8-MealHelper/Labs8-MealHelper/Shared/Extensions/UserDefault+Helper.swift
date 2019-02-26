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
        case email
        case token
    }
    
    func logoutUser() {
        set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        set(nil, forKey: UserDefaultsKeys.userId.rawValue)
        set(nil, forKey: UserDefaultsKeys.zipCode.rawValue)
        set(nil, forKey: UserDefaultsKeys.email.rawValue)
        set(nil, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func setIsLoggedIn(value: Bool, userId: Int?, zipCode: Int?, email: String?, token: String?) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        set(userId, forKey: UserDefaultsKeys.userId.rawValue)
        set(zipCode, forKey: UserDefaultsKeys.zipCode.rawValue)
        set(email, forKey: UserDefaultsKeys.email.rawValue)
        set(token, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func setZipCode(zip: Int) {
        set(zip, forKey: UserDefaultsKeys.zipCode.rawValue)
    }
    
    func setEmail(email: String) {
        set(email, forKey: UserDefaultsKeys.email.rawValue)
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func loggedInUserId() -> Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    func loggedInZipCode() -> Int {
        return integer(forKey: UserDefaultsKeys.zipCode.rawValue)
    }
    
    func loggedInEmail() -> String? {
        return string(forKey: UserDefaultsKeys.email.rawValue)
    }
    
    func loggedInToken() -> String? {
        return string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func loggedInUser() -> User? {
        guard let email = loggedInEmail(), let token = loggedInToken() else { return nil }
        return User(email: email, zip: loggedInZipCode(), id: loggedInUserId(), token: token)
    }
}
