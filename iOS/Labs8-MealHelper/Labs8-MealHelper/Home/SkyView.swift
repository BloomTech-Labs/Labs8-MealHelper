//
//  SkyView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 29/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class SkyView: UIView {
    
    let moonSunImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0

        return iv
    }()
    
    private var weather: WeatherForecast?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func fetchWeather() {
        if let weather = weather {
            calculateWeatherAnimation(forecast: weather)
        } else {
            WeatherAPIClient.shared.fetchWeather(for: 3300) { (forecast) in
                
                DispatchQueue.main.async {
                    guard let forecast = forecast else {
                        self.setGradientBackground(colorOne: UIColor.morningSkyBlue.cgColor, colorTwo: UIColor.mountainBlue.cgColor, startPoint: .zero, endPoint: CGPoint(x: 0.8, y: 0.3))
                        return
                    }
                    self.calculateWeatherAnimation(forecast: forecast)
                    self.weather = forecast
                }
            }
        }
    }
    
    private func calculateWeatherAnimation(forecast: WeatherForecast) {
        
        let sunDuration = forecast.sys.sunset - forecast.sys.sunrise
        let now = Int(Date().timeIntervalSince1970)
        
        if now < forecast.sys.sunset && now > forecast.sys.sunrise {
            
            self.setGradientBackground(colorOne: UIColor.morningSkyBlue.cgColor, colorTwo: UIColor.mountainBlue.cgColor, startPoint: .zero, endPoint: CGPoint(x: 0.8, y: 0.3))
            let timeSinceSunrise = now - forecast.sys.sunrise
            let percentage = (Double(timeSinceSunrise) / Double(sunDuration)) * 100
            let roundedPercentage = percentage.rounded(toPlaces: 3)
            let minusDuration = (Double(sunDuration) / 100) * roundedPercentage
            let duration = sunDuration - Int(minusDuration)
            let startAngle = Int((179 * (roundedPercentage / 100)) + 180)
            startAnimation(with: #imageLiteral(resourceName: "sun"), duration: duration, startAngle: startAngle)
            
            let rotateAnim = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnim.fromValue = 0
            rotateAnim.toValue = CGFloat.pi * 2
            rotateAnim.duration = 20
            rotateAnim.repeatCount = .infinity
            
            moonSunImageView.layer.add(rotateAnim, forKey: "rotate")
            
        } else if now > forecast.sys.sunset {
            
            let nextDaySunrise = forecast.sys.sunrise + 86400 //86400 seconds = 24 hours
            let moonDuration = nextDaySunrise - forecast.sys.sunset
            
            self.setGradientBackground(colorOne: UIColor.nightSkyDark.cgColor, colorTwo: UIColor.nightSkyBlue.cgColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 0.3))
            let timeSinceSunset = now - forecast.sys.sunset
            let percentage = (Double(timeSinceSunset) / Double(moonDuration)) * 100
            let roundedPercentage = percentage.rounded(toPlaces: 2)
            let minusDuration = (Double(moonDuration) / 100) * roundedPercentage
            let duration = moonDuration - Int(minusDuration)
            let startAngle = Int((179 * (roundedPercentage / 100)) + 180)
            startAnimation(with: #imageLiteral(resourceName: "moon"), duration: duration, startAngle: startAngle)
        } else if now < forecast.sys.sunrise {
            let lastDaySunset = forecast.sys.sunset - 86400
            let moonDuration = forecast.sys.sunrise - lastDaySunset
            
            self.setGradientBackground(colorOne: UIColor.nightSkyDark.cgColor, colorTwo: UIColor.nightSkyBlue.cgColor, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0.8, y: 0.3))
            
            let timeSinceSunset = now - lastDaySunset
            let percentage = (Double(timeSinceSunset) / Double(moonDuration)) * 100
            let roundedPercentage = percentage.rounded(toPlaces: 2)
            let minusDuration = (Double(moonDuration) / 100) * roundedPercentage
            let duration = moonDuration - Int(minusDuration)
            let startAngle = Int((179 * (roundedPercentage / 100)) + 180)
            startAnimation(with: #imageLiteral(resourceName: "moon"), duration: duration, startAngle: startAngle)
        }
    }
    
    private func startAnimation(with image: UIImage, duration: Int, startAngle: Int) {
        moonSunImageView.image = image
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY + 50), radius: self.bounds.width / 2, startAngle: CGFloat(startAngle).toRadians(), endAngle: CGFloat(0).toRadians(), clockwise: true)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = .forwards
        animation.delegate = self
        
        moonSunImageView.layer.add(animation, forKey: nil)
        addSubview(moonSunImageView)
        
        UIView.animate(withDuration: 1) {
            self.moonSunImageView.alpha = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SkyView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            moonSunImageView.alpha = 0
            moonSunImageView.removeFromSuperview()
            fetchWeather()
            layoutIfNeeded()
        } else {
            moonSunImageView.alpha = 0
            moonSunImageView.removeFromSuperview()
        }
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180.0
    }
}
