//
//  WeatherView.swift
//  WeatherView
//
//  Created by Simon Elhoej Steinmejer on 16/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class WeatherLabel: UILabel {
    convenience init(type: String, value: String) {
        self.init()
        self.sizeToFit()
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        updateText(type: type, value: value)
    }
    
    func updateText(type: String, value: String) {
        let attributedText = NSMutableAttributedString(string: "\(type)\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: Appearance.appFont(with: 12)])
        attributedText.append(NSAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: Appearance.appFont(with: 16)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.count))
        self.attributedText = attributedText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WeatherView: UIView
{
    let temperatureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "temperature").withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        return iv
    }()
    
    let humidityImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "humidity").withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        return iv
    }()
    
    let pressureImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "pressure").withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        
        return iv
    }()
    
    let forecastLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.text = "The forecast for that day was CLEAR SKY"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let temperatureLabel = WeatherLabel(type: "Temperature", value: "0°C")
    let humidityLabel = WeatherLabel(type: "Humidity", value: "00.0")
    let pressureLabel = WeatherLabel(type: "Pressure", value: "0000")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        self.layer.masksToBounds = true
        
        setupViews()
    }
    
    func updateWeather(temperature: Double, humidity: Double, pressure: Double) {
        let temperatureString = "\(Int(temperature))°C"
        temperatureLabel.updateText(type: "Temperature", value: temperatureString)
        let humidityString = "\(humidity)%"
        humidityLabel.updateText(type: "Humidity", value: humidityString)
        let pressureString = "\(Int(pressure))"
        pressureLabel.updateText(type: "Pressure", value: pressureString)
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
       
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, pressureLabel])
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 16, bottom: 12, right: 16))
    }
}
