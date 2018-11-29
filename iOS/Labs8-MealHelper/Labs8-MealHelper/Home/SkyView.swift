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
        animation.duration = 60
        animation.fillMode = .forwards
        animation.delegate = self
        
        moonSunImageView.layer.add(animation, forKey: nil)
        addSubview(moonSunImageView)
    }
    
    override func draw(_ rect: CGRect) {
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY + 100), radius: self.bounds.width / 2, startAngle: CGFloat(180).toRadians(), endAngle: CGFloat(0).toRadians(), clockwise: true)
//        path?.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.midY))
//        path?.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: self.bounds.midY), controlPoint: CGPoint(x: self.bounds.midX, y: self.bounds.midY - 200))
        
        
//        path?.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: self.bounds.height / 2, startAngle: 180, endAngle: 0, clockwise: true)
//        path?.lineWidth = 2
//        UIColor.clear.setStroke()
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
