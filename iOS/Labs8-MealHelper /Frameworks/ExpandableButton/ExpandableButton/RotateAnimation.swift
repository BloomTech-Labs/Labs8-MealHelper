//
//  RotateAnimation.swift
//  SlimeButton
//
//  Created by Simon Elhoej Steinmejer on 06/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class RotateAnimation: CABasicAnimation {
    
    private var clockwise: Bool
    
    init(clockwise: Bool) {
        self.clockwise = clockwise
        super.init()
        setupValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        clockwise = true
        super.init()
    }
    
    private func setupValues() {
        keyPath = "transform.rotation"
        fromValue = clockwise ? 0 : CGFloat.pi as NSNumber
        toValue = clockwise ? CGFloat.pi : 0 as NSNumber
        isAdditive = true
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        duration = 0.4
    }
}
