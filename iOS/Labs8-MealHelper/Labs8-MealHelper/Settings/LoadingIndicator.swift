//
//  LoadinIndicator.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 10/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import Lottie

class LoadingIndicator {
    
    let animationView: LOTAnimationView = {
        let lav = LOTAnimationView()
        lav.setAnimation(named: "loading")
        lav.loopAnimation = true
        lav.alpha = 0
        
        return lav
    }()
    
    let blackBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        return view
    }()
    
    func showLoadingAnimation() {
        if let keywindow = UIApplication.shared.keyWindow {
            
            keywindow.addSubview(blackBackgroundView)
            blackBackgroundView.fillSuperview()
            blackBackgroundView.addSubview(animationView)
            animationView.centerInSuperview(size: CGSize(width: 200, height: 200))
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.blackBackgroundView.alpha = 1
                self.animationView.alpha = 1
                
            }) { (completed) in
                
                self.animationView.play()
            }
        }
    }
    
    func finishLoadingAnimation() {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.blackBackgroundView.alpha = 0
            self.animationView.alpha = 0
            
        }) { (completed) in
            
            self.blackBackgroundView.removeFromSuperview()
            self.animationView.stop()
        }
    }
}
