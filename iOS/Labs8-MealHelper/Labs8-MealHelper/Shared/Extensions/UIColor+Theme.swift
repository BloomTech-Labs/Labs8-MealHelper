//
//  UIColor+Theme.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 25/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

extension UIColor
{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let darkColor = UIColor.rgb(red: 0, green: 52, blue: 89)
    static let darkBlue = UIColor.rgb(red: 0, green: 52, blue: 89)
    static let lightBlue = UIColor.rgb(red: 0, green: 168, blue: 232)
    static let lightPurple = UIColor.rgb(red: 59, green: 206, blue: 172)
    static let correctGreen = UIColor.rgb(red: 76, green: 185, blue: 68)
    static let incorrectRed = UIColor.rgb(red: 254, green: 95, blue: 85)
    static let goldColor = UIColor.rgb(red: 255, green: 218, blue: 33)
    static let silver = UIColor.rgb(red: 220, green: 220, blue: 221)
    static let bronze = UIColor.rgb(red: 161, green: 105, blue: 40)
    static let sunOrange = UIColor.rgb(red: 255, green: 111, blue: 56)
    static let sunRed = UIColor.rgb(red: 226, green: 17, blue: 58)
    static let mountainBlue = UIColor.rgb(red: 47, green: 157, blue: 254)
    static let mountainDark = UIColor.rgb(red: 36, green: 36, blue: 36)
    static let nightSkyBlue = UIColor.rgb(red: 5, green: 102, blue: 141)
    static let nightSkyDark = UIColor.rgb(red: 11, green: 19, blue: 43)
    static let morningSkyBlue = UIColor.rgb(red: 105, green: 221, blue: 255)
}

enum Appearance
{
    static func appFont(with size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    
    static func setupNavBar() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Appearance.appFont(with: 20)]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Appearance.appFont(with: 30)]
//        UINavigationBar.appearance().isTranslucent = false
    }
}
