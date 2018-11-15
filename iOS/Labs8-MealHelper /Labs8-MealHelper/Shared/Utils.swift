//
//  Utils.swift
//  ios-meal-helper
//
//  Created by De MicheliStefano on 06.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

struct Utils {
    
    func getPersonHeightString(_ cm: Double) -> String {
        let massFormatter = LengthFormatter()
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = false
        massFormatter.numberFormatter = numberFormatter
        massFormatter.isForPersonHeightUse = true
        return massFormatter.string(fromMeters: cm / 100)
    }
    
     func getPersonWeightString(_ kg: Double) -> String {
        let massFormatter = MassFormatter()
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = false
        massFormatter.numberFormatter = numberFormatter
        massFormatter.isForPersonMassUse = true
        return massFormatter.string(fromKilograms: kg)
    }
    
    func dateString(for date: Date, in locale: Locale = Locale(identifier: Locale.current.identifier)) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
    
    func dateAndTimeString(for date: Date, in locale: Locale = Locale(identifier: Locale.current.identifier)) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
    
}
