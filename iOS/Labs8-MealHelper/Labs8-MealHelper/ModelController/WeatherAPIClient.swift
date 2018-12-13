//
//  WeatherAPIClient.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 12/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class WeatherAPIClient: GenericAPIClient {

    static let shared = WeatherAPIClient()
        
    let apiKey = "041197f9dce59be074281a9d3405c8ca"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        
    func fetchWeather(for zipCode: Int, completion: @escaping (WeatherForecast?) -> ())
    {
        guard let countryCode = Locale.current.regionCode?.lowercased() else { return }
            
        let url = URL(string: baseURL)!
        let zipQuery = URLQueryItem(name: "zip", value: "\(String(zipCode)),\(countryCode)")
        let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
        let metricQuery = URLQueryItem(name: "units", value: "metric")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [metricQuery ,zipQuery, apiKeyQuery]
        
        guard let finalUrl = urlComponents?.url else { return }
        var urlRequest = URLRequest(url: finalUrl)
        urlRequest.httpMethod = "GET"
            
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                
            if let error = error
            {
                NSLog("Error fetching weather forecast: \(error)")
                completion(nil)
                return
            }
                
            guard let data = data else {
                NSLog("Couldn't unwrap data")
                completion(nil)
                return
            }
                
            do {
                let forecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                completion(forecast)
                    
            } catch {
                NSLog("Error decoding weather: \(error)")
                completion(nil)
                return
            }
        }.resume()
    }
}
