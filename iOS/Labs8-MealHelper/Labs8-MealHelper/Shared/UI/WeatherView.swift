//
//  WeatherView.swift
//  WeatherView
//
//  Created by Simon Elhoej Steinmejer on 16/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class WeatherView: UIView
{
    var forecast: WeatherForecast?
    {
        didSet
        {
            guard let forecast = forecast else { return }
            
            let forecastAttributedText = NSMutableAttributedString(string: "The forecast on that day was ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            forecastAttributedText.append(NSAttributedString(string: forecast.weather.first?.description ?? "Shiny", attributes: [NSAttributedString.Key.foregroundColor: UIColor.correctGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
            forecastAttributedText.append(NSAttributedString(string: " with a temperature of ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            forecastAttributedText.append(NSAttributedString(string: "\(String(forecast.main.temp))°C", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mountainBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            forecastAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: forecastAttributedText.string.count))
            
            forecastLabel.attributedText = forecastAttributedText
            
            let humidityAttributedText = NSMutableAttributedString(string: "Humidity\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            humidityAttributedText.append(NSAttributedString(string: String(forecast.main.humidity), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
            
            humidityAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: humidityAttributedText.string.count))
            
            humidityLabel.attributedText = humidityAttributedText
            
            let pressureAttributedText = NSMutableAttributedString(string: "Pressure\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            pressureAttributedText.append(NSAttributedString(string: String(forecast.main.pressure), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
            
            pressureAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: pressureAttributedText.string.count))
            
            pressureLabel.attributedText = pressureAttributedText
        }
    }
    
    let forecastLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    let humidityLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    let pressureLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        self.layer.masksToBounds = true
        
        setupViews()
        
        fetch()
    }
    
    func fetch()
    {
        let zipCode = UserDefaults.standard.loggedInZipCode()
        WeatherAPIClient.shared.fetchWeather(for: zipCode) { (forecast) in
            
            guard let forecast = forecast else { return }
            
            DispatchQueue.main.async {
                self.forecast = forecast
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews()
    {
        let horizontalStackView = UIStackView(arrangedSubviews: [humidityLabel, pressureLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.distribution = .fillEqually
        
        let verticalStackView = UIStackView(arrangedSubviews: [forecastLabel, horizontalStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 12
        verticalStackView.distribution = .fillEqually
        
        addSubview(verticalStackView)
        
        verticalStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20), size: .zero)
        
//        forecastLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 20), size: .zero)
        
        
    }
}
