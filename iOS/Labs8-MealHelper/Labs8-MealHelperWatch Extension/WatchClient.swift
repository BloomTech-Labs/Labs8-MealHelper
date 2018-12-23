//
//  WatchClient.swift
//  Labs8-MealHelperWatch Extension
//
//  Created by De MicheliStefano on 14.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class WatchClient {
    var manager: URLSession!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        manager = URLSession(configuration: configuration)
    }
    
    let baseUrl: URL = URL(string: "https://labs8-meal-helper.herokuapp.com/")!
    
    func fetchRecipes(for userId: Int, using session: URLSession = URLSession.shared, completion: @escaping (([Recipe]?, Error?) -> ())) {
        
        
        let url = self.url(with: baseUrl, pathComponents: ["recipe", "user", String(userId)])
        
        manager.dataTask(with: url) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with FETCH urlRequest: \(error)")
                completion(nil, NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(nil, NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
                    completion(nil, NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil))
                    return
                }
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                completion(recipes, nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(nil, NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil))
                return
            }
        }.resume()
    }
    
//    func postMeal(with recipe: Recipe, requestBody: Dictionary<String, Any>, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = HTTPMethod.post.rawValue
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            let requestBody = requestBody
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) //encoder.encode(requestBody)
//            urlRequest.httpBody = jsonData
//        } catch {
//            NSLog("Failed to encode foods: \(error)")
//            completion(Response.error(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
//
//            if let error = error {
//                NSLog("Error with POST urlRequest: \(error)")
//                completion(Response.error(error))
//                return
//            }
//
//            guard let data = data else {
//                NSLog("No data returned")
//                completion(Response.error(NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil)))
//                return
//            }
//
//            if let httpResponse = res as? HTTPURLResponse {
//                if httpResponse.statusCode != 200 {
//                    NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
//                    completion(Response.error(NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil)))
//                    return
//                }
//            }
//
//            do {
//                let response = try JSONDecoder().decode(Resource.self, from: data)
//                completion(Response.success(response))
//            } catch {
//                NSLog("Error decoding data: \(error)")
//                completion(Response.error(error))
//                return
//            }
//            }.resume()
//    }
    
    func url(with baseUrl: URL, pathComponents: [String]) -> URL {
        var url = baseUrl
        pathComponents.forEach { url.appendPathComponent($0) }
        return url
    }
    
}

struct Recipe: Codable, Equatable {
    
    var identifier: Int
    var name: String
    var calories: String
    var servings: Int
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case calories
        case servings
        case userId = "user_id"
    }
}
