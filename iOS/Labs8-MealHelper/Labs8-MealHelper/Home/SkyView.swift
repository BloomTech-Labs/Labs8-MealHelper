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
    var startAngle = 180 {
        didSet {
            setNeedsLayout()
        }
    }
    
    let moonSunImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        iv.contentMode = .scaleAspectFit

        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fetchWeather()
    }
    
    private func fetchWeather() {
        WeatherAPIClient.shared.fetchWeather(for: 3300) { (forecast) in
            
            guard let forecast = forecast else { return }
            DispatchQueue.main.async {
                self.calculateWeatherAnimation(forecast: forecast)
            }
        }
    }
    
    private func calculateWeatherAnimation(forecast: WeatherForecast) {
        
        let sunDuration = forecast.sys.sunset - forecast.sys.sunrise
        let nextDaySunrise = forecast.sys.sunrise + 86400 //86400 seconds = 24 hours
        let moonDuration = nextDaySunrise - forecast.sys.sunset
        let now = Int(Date().timeIntervalSince1970)
        
        if now < forecast.sys.sunset && now > forecast.sys.sunrise {
            
            self.setGradientBackground(colorOne: UIColor.morningSkyBlue.cgColor, colorTwo: UIColor.mountainBlue.cgColor, startPoint: .zero, endPoint: CGPoint(x: 0.8, y: 0.3))
            let timeSinceSunrise = now - forecast.sys.sunrise
            let percentage = Double(timeSinceSunrise) / Double(sunDuration)
            let roundedPercentage = percentage.rounded(toPlaces: 3)
            self.startAngle = Int((179 * (roundedPercentage / 100)) + 180)
            let minusDuration = (Double(sunDuration) / 100) * roundedPercentage
            let duration = sunDuration - Int(minusDuration)
            startAnimation(with: #imageLiteral(resourceName: "sun"), duration: duration)
            
        } else if now > forecast.sys.sunset && now < nextDaySunrise {
            
            self.setGradientBackground(colorOne: UIColor.nightSkyDark.cgColor, colorTwo: UIColor.nightSkyBlue.cgColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 0.3))
            let timeSinceSunset = now - forecast.sys.sunset
            let percentage = (Double(timeSinceSunset) / Double(moonDuration)) * 100
            let roundedPercentage = percentage.rounded(toPlaces: 2)
            self.startAngle = Int((179 * (roundedPercentage / 100)) + 180)
            let minusDuration = (Double(moonDuration) / 100) * roundedPercentage
            let duration = moonDuration - Int(minusDuration)
            startAnimation(with: #imageLiteral(resourceName: "moon"), duration: duration)
        }
    }
    
    private func startAnimation(with image: UIImage, duration: Int) {
        moonSunImageView.image = image
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = self.path?.cgPath
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = .forwards
        animation.delegate = self
        animation.delegate = self
        
        moonSunImageView.layer.add(animation, forKey: nil)
        addSubview(moonSunImageView)
    }
    
    override func draw(_ rect: CGRect) {
        path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY + 50), radius: self.bounds.width / 2, startAngle: CGFloat(startAngle).toRadians(), endAngle: CGFloat(0).toRadians(), clockwise: true)
        path?.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SkyView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        moonSunImageView.removeFromSuperview()
        fetchWeather()
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180.0
    }
}
