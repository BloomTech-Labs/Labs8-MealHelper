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
}
