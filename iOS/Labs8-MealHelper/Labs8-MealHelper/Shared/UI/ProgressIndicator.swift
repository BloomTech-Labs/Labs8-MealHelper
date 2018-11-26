//
//  ProgressIndicator.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 16.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ProgressIndicator: UIView {
    
    // MARK: - Properties
    
    var lineWidth: CGFloat = 40.0
    var bgLineWidth: CGFloat = 7.5
    var fgLineWidth: CGFloat = 12.0
    var bgColor = UIColor(white: 1.0, alpha: 0.5).cgColor
    var fgColor = UIColor.white.cgColor
    var progressValue: Double!
    var goalValue: Double!
    var progressPercentage: CGFloat {
        if (progressValue >= goalValue) {
            return 1.0
        }
        return CGFloat(progressValue) / CGFloat(goalValue)
    }
    var label: String!
    var animationDuration: CFTimeInterval!
    var fontSize: CGFloat = 20.0
    var fontColor = UIColor.white
    
    private var metricLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let bgLayer = CAShapeLayer()
    private let fgLayer = CAShapeLayer()
    private let margin: CGFloat = 20
    private var startValue = 0.0
    private let animationStartDate = Date()
    
    // MARK: - Init
    
    init(frame: CGRect, progress: Double, goal: Double, label: String? = "", animationDuration: CFTimeInterval? = 1.2) {
        super.init(frame: frame)
        self.progressValue = progress
        self.goalValue = goal
        self.animationDuration = animationDuration
        self.label = label
        setupViews()
        animateProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShapeLayer(bgLayer)
        setupShapeLayer(fgLayer)
    }
    
    // MARK: - Public
    
    func animateProgress() {
        let activityAnimation = CABasicAnimation(keyPath: "strokeEnd")
        activityAnimation.fromValue = 0.0
        activityAnimation.toValue = progressPercentage
        activityAnimation.duration = animationDuration
        activityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fgLayer.add(activityAnimation, forKey: nil)
        
        // Make the count up from startValue to final progressValue visible to the user
        let displayLink = CADisplayLink(target: self, selector: #selector(handleValueUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc func handleValueUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            metricLabel.text = String(format: "%.0f", progressValue)
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (progressValue - startValue)
            metricLabel.text = String(format: "%.0f", value)
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        bgLayer.lineWidth = bgLineWidth
        bgLayer.fillColor = nil
        bgLayer.strokeColor = bgColor
        bgLayer.strokeEnd = 1.0
        layer.addSublayer(bgLayer)
        
        fgLayer.lineWidth = fgLineWidth
        fgLayer.fillColor = nil
        fgLayer.strokeColor = fgColor
        fgLayer.strokeEnd = progressPercentage
        layer.addSublayer(fgLayer)
        
        setupShapeLayer(bgLayer)
        setupShapeLayer(fgLayer)
        
        metricLabel.font = UIFont.systemFont(ofSize: fontSize)
        metricLabel.textColor = fontColor
        metricLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(metricLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: fontSize)
        descriptionLabel.text = label
        descriptionLabel.textColor = fontColor
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        metricLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        metricLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -margin).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: metricLabel.bottomAnchor, constant: margin).isActive = true
    }
    
    private func setupShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = self.bounds
        let startAngle = DegreesToRadians(value: 135.0)
        let endAngle = DegreesToRadians(value: 45.0)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = self.bounds.width * 0.35
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.path = path.cgPath
    }
    
}
