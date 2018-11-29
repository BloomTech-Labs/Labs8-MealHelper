//
//  WeatherForecast.swift
//  WeatherView
//
//  Created by Simon Elhoej Steinmejer on 16/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

struct WeatherForecast: Decodable {
    
//    var description: String
//    var id: Int
    var weather: [Weather]
    var main: Main

    enum CodingKeys: String, CodingKey
    {
        case weather
        case main
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
}
//
//    enum StatsCodingKeys: String, CodingKey
//    {
//        case temp
//        case humidity
//        case pressure
//    }
//
//    enum WeatherCodingKeys: String, CodingKey
//    {
//        case weather
//    }
    
//    public init(from decoder: Decoder) throws
//    {
//        let mainContainer = try decoder.container(keyedBy: MainCodingKeys.self)
//        let statsContainer = try mainContainer.nestedContainer(keyedBy: StatsCodingKeys.self, forKey: .main)
//        let temp = try statsContainer.decode(Int.self, forKey: .temp)
//        let humidity = try statsContainer.decode(Int.self, forKey: .humidity)
//        let pressure = try statsContainer.decode(Int.self, forKey: .pressure)
//
//        self.temp = temp
//        self.humidity = humidity
//        self.pressure = pressure
////        self.description = description
////        self.id = id
//    }

//
//{
//    "coord": {
//        "lon": 12.02,
//        "lat": 55.97
//    },
//    "weather": [
//    {
//    "id": 800,
//    "main": "Clear",
////    "description": "clear sky",
////    "icon": "01d"
//    }
//    ],
//    "base": "stations",
//    "main": {
////        "temp": 9,
////        "pressure": 1035,
////        "humidity": 70,
//        "temp_min": 9,
//        "temp_max": 9
//    },
//    "wind": {
//        "speed": 6.7,
//        "deg": 160
//    },
//    "clouds": {
//        "all": 0
//    },
//    "dt": 1542367200,
//    "sys": {
//        "type": 1,
//        "id": 5256,
//        "message": 0.0041,
//        "country": "DK",
//        "sunrise": 1542351060,
//        "sunset": 1542380510
//    },
//    "id": 490001092,
//    "name": "Copenhagen",
//    "cod": 200
//}
