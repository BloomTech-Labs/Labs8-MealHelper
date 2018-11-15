//
//  LoginTextField.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 14/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class LeftIconTextField: UITextField
{
    var leftImage: UIImage?
    {
        didSet
        {
            updateView()
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect
    {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += 10
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        guard let leftViewWidth = self.leftView?.bounds.width,  let leftViewspacing = self.leftView?.frame.minX else { return CGRect.zero }
        let textSpacing: CGFloat = 10
        let textOffset = leftViewWidth + leftViewspacing + textSpacing
        return CGRect(origin: CGPoint(x: textOffset, y: 0), size: bounds.size)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        guard let leftViewWidth = self.leftView?.bounds.width,  let leftViewspacing = self.leftView?.frame.minX else { return CGRect.zero }
        let textSpacing: CGFloat = 10
        let textOffset = leftViewWidth + leftViewspacing + textSpacing
        return CGRect(origin: CGPoint(x: textOffset, y: 0), size: bounds.size)
    }
    
    func updateView()
    {
        if let image = leftImage
        {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .white
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.tintColor = .lightPurple
    }
}
