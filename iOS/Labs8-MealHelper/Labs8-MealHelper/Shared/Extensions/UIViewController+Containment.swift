//
//  UIViewController+Containment.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 28.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
