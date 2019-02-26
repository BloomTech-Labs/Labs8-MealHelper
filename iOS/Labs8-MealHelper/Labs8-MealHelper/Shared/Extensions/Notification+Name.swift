//
//  Notification+Name.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 27.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

extension Notification.Name {
    // MH = suffix for MealHelper
    
    static let MHFoodSummaryPickerDidChange = Notification.Name("MHFoodSummaryPickerDidChange")
    static let MHFoodSummaryTextFieldDidChange = Notification.Name("MHFoodSummaryTextFieldDidChange")
    static let MHEmailDidChange = Notification.Name("MHEmailDidChange")
    static let MHZipCodeDidChange = Notification.Name("MHZipCodeDidChange")
}
