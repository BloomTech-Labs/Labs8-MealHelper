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
    
    // TODO: to be deleted. just a hack for saving data
    var recipes = [
        Recipe(name: "Smørrebrød", calories: 123, servings: 1, ingredients: [], userId: 1, mealId: 1),
        Recipe(name: "Leverpostej", calories: 123, servings: 1, ingredients: [], userId: 1, mealId: 1),
        Recipe(name: "Fiskefrikadeller", calories: 123, servings: 1, ingredients: [], userId: 1, mealId: 1),
        Recipe(name: "Mørbradbøffer", calories: 123, servings: 1, ingredients: [], userId: 1, mealId: 1),
        Recipe(name: "Æbleflæsk", calories: 123, servings: 1, ingredients: [], userId: 1, mealId: 1)
    ]
    
    let usdaBaseUrl: URL = URL(string: "https://api.nal.usda.gov/ndb/search/")!
    let usdaAPIKey = "c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6"
    let baseUrl: URL = URL(string: "https://labs8-meal-helper.herokuapp.com/")!
    var userId = Constants.User().id // TODO: to be deleted.
    //var userId = String(UserDefaults().loggedInUserId())
    
    // MARK: - Meal Helper
    
    func fetchMeals(for user: User, completion: @escaping (Response<[Meal]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", userId, "meals"])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchRecipes(for user: User, completion: @escaping (Response<[Recipe]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchIngredients(for user: User, completion: @escaping (Response<[Ingredient]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func postMeal(with userCredentials: User, mealTime: String, experience: String?, date: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", userId, "meals"])
        let reqBody = [
            "user_id": userId,
            "mealTime": mealTime,
            "experience": experience,
            "date": date
        ]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    
    func postIngredient(with userCredentials: User, name: String, nutrientId: String?, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        let reqBody = ["name": name, "nutrients_id": nutrientId]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    // MARK: USDA
    
    func fetchUsdaIngredients(with searchTerm: String, completion: @escaping (Response<[Ingredient]>) -> ()) {
        var urlComponents = URLComponents(url: usdaBaseUrl, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "sort", value: "n"),
            URLQueryItem(name: "max", value: "25"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "api_key", value: usdaAPIKey),
            URLQueryItem(name: "q", value: searchTerm)
        ]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(searchTerm)")
            completion(Response.error(NSError()))
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with urlRequest: \(error)")
                completion(Response.error(error))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError()))
                return
            }
            
            do {
                // TODO: - Handle fetches that didn't return any results (returns a different json)
                let usdaIngredients = try JSONDecoder().decode(UsdaIngredients.self, from: data)
                let ingredients: [Ingredient] = self.convertToIngredient(usdaIngredients.list.item)
                completion(Response.success(ingredients))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
            
        }.resume()
    }
    
    // MARK: - Generic methods
    
    private func fetch<Resource: Codable>(from url: URL, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
        session.dataTask(with: url) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with fetching foods: \(error)")
                completion(Response.error(error))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let foods = try JSONDecoder().decode(Resource.self, from: data)
                completion(Response.success(foods))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
            
        }.resume()
    }
    
    private func post<Resource: Codable>(with url: URL, requestBody: Dictionary<String, String?>, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = requestBody
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let requestBodyJson = try encoder.encode(requestBody)
            urlRequest.httpBody = requestBodyJson
        } catch {
            NSLog("Failed to encode foods: \(error)")
            completion(Response.error(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with urlRequest: \(error)")
                completion(Response.error(error))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError(domain: "com.stefano.Labs8-MealHelper.ErrorDomain", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Resource.self, from: data)
                completion(Response.success(response))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
    }
    
    // MARK: - Private methods
    
    private func url(with baseUrl: URL, pathComponents: [String]) -> URL {
        var url = baseUrl
        pathComponents.forEach { url.appendPathComponent($0) }
        return url
    }
    
    private func convertToIngredient(_ usdaIngredients: [UsdaIngredients.Item.UsdaIngredient]) -> [Ingredient] {
        return usdaIngredients.map { Ingredient(name: $0.name, nbdId: $0.ndbId) }
    }
    
}
