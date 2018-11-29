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
    static let MHFoodSummaryTypePickerDidChange = Notification.Name("MHFoodSummaryTypePickerDidChange")
    static let MHFoodSummaryQuantityPickerDidChange = Notification.Name("MHFoodSummaryQuantityPickerDidChange")
    static let MHFoodSummaryTextFieldDidChange = Notification.Name("MHFoodSummaryTextFieldDidChange")
    
}
