//
//  WeatherForecast.swift
//  WeatherView
//
//  Created by Simon Elhoej Steinmejer on 16/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct WeatherForecast: Decodable {
    
    var weather: [Weather]
    var main: Main
    var sys: Sys

    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case sys
    }
    
    struct Main: Decodable {
        var temp: Double
        var humidity: Double
        var pressure: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case humidity
            case pressure
        }
    }
    
    struct Weather: Decodable {
        var id: Int
        var description: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case description
        }
    }
    
    struct Sys: Decodable {
        var sunrise: Int
        var sunset: Int
        
        enum CodingKeys: String, CodingKey {
            case sunrise
            case sunset
        }
    }
}
