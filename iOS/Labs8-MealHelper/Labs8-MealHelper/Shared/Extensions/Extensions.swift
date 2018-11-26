//
//  Extensions.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 15/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

extension UIViewController
{
    func showAlert(with text: String)
    {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView
{
    func setGradientBackground(colorOne: CGColor, colorTwo: CGColor, startPoint: CGPoint, endPoint: CGPoint)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
