//
//  SkyView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 29/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SkyView: UIView {
    
    var path: UIBezierPath?
    
    let moonSunImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        iv.contentMode = .scaleAspectFit

        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animate()
        }
    }
    
    func animate() {
        moonSunImageView.image = #imageLiteral(resourceName: "moon")
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = self.path?.cgPath
        animation.duration = 2000
        animation.fillMode = .forwards
        animation.delegate = self
        
        moonSunImageView.layer.add(animation, forKey: nil)
        addSubview(moonSunImageView)
    }
    
    override func draw(_ rect: CGRect) {
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY + 50), radius: self.bounds.width / 2, startAngle: CGFloat(225).toRadians(), endAngle: CGFloat(0).toRadians(), clockwise: true)
        path?.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SkyView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        moonSunImageView.removeFromSuperview()
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180.0
    }
}