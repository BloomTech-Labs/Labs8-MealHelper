//
//  FoodClient.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 15.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class FoodClient {
    
    static let shared = FoodClient()
    let usdaBaseUrl: URL = URL(string: "https://api.nal.usda.gov/ndb/search/")!
    let usdaAPIKey = "c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6"
    let baseUrl: URL = URL(string: "https://labs8-meal-helper.herokuapp.com/")!
    
    // MARK: - Public
    
    func fetchRecipes(for user: User, completion: @escaping (Response<[Recipe]>) -> ()) {
        var url = baseUrl
        url.appendPathComponent("recipe")
        url.appendPathComponent("1")
        
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with urlReqeust: \(error)")
                completion(Response.error(error))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError()))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                completion(Response.success(recipes))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
    }
    
    func fetchIngredients(with searchTerm: String, completion: @escaping (Response<[usdaIngredients.usdaIngredient]>) -> ()) {
        var urlComponents = URLComponents(url: usdaBaseUrl, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "sort", value: "n"),
            URLQueryItem(name: "max", value: "25"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "offset", value: usdaAPIKey)
        ]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(searchTerm)")
            completion(Response.error(NSError()))
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with urlReqeust: \(error)")
                completion(Response.error(error))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError()))
                return
            }
            
            do {
                let ingredients = try JSONDecoder().decode(usdaIngredients.self, from: data)
                completion(Response.success(ingredients.items))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
            
        }.resume()
    }
    
    // MARK: - Private
    
}

//private func fetch<T: Codable>(from url: URL,
//                               using session: URLSession = URLSession.shared,
//                               completion: @escaping (T?, Error?) -> Void) {
//    session.dataTask(with: url) { (data, response, error) in
//        if let error = error {
//            completion(nil, error)
//            return
//        }
//
//        guard let data = data else {
//            completion(nil, NSError(domain: "com.LambdaSchool.Astronomy.ErrorDomain", code: -1, userInfo: nil))
//            return
//        }
//
//        do {
//            let jsonDecoder = MarsPhotoReference.jsonDecoder
//            let decodedObject = try jsonDecoder.decode(T.self, from: data)
//            completion(decodedObject, nil)
//        } catch {
//            completion(nil, error)
//        }
//        }.resume()
//}
