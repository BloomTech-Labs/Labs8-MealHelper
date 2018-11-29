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
    var nutrients = ["208", "269", "204", "205"]
    
    let usdaBaseUrl: URL = URL(string: "https://api.nal.usda.gov/ndb/")!
    let usdaAPIKey = "c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6"
    let baseUrl: URL = URL(string: "https://labs8-meal-helper.herokuapp.com/")!
    var userId = Constants.User().id // TODO: to be deleted.
    //var userId = String(UserDefaults().loggedInUserId())
    
    // MARK: - Meal Helper
    
    func fetchMeals(completion: @escaping (Response<[Meal]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", userId, "meals"])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchRecipes(completion: @escaping (Response<[Recipe]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchIngredients(completion: @escaping (Response<[Ingredient]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func postMeal(name: String, mealTime: String, date: String, temp: Double, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", userId, "meals"])
        let reqBody = [
            "name": name,
            "user_id": userId,
            "mealTime": mealTime,
            "date": date,
            "temp": temp
            ] as [String : Any]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postRecipe(name: String, calories: Int, servings: Int, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", userId])
        let reqBody = ["name": name, "calories": calories, "servings": servings] as [String : Any]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postIngredient(_ ingredient: Ingredient, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        let reqBody = ["name": ingredient.name, "ndbno": ingredient.nbdId]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func putIngredient(withId ingredientId: Int, nutrientIds: [Int], completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", "ingredients", String(ingredientId)])
        let reqBody = ["ids": nutrientIds]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postNutrient(_ nutrient: Nutrient, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", userId])
        let reqBody = ["name": nutrient.name, "unit": nutrient.unit, "value": nutrient.value] as [String : Any]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postNutrient(nutrientId: String, ingredientId: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", ingredientId])
        let reqBody = ["id": nutrientId]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func deleteMeal(withId id: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", id, "meals"])
        
        delete(with: url, completion: completion)
        
    }
    
    func deleteRecipe(withId id: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", id])
        
        delete(with: url, completion: completion)
        
    }
    
    func deleteIngredient(withId id: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", id])
        
        delete(with: url, completion: completion)
        
    }
    
    func deleteNutrient(withId id: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", id])
        
        delete(with: url, completion: completion)
        
    }
    
    // MARK: USDA
    
    func fetchUsdaIngredients(with searchTerm: String, completion: @escaping (Response<[Ingredient]>) -> ()) {
        let url = self.url(with: usdaBaseUrl, pathComponents: ["search"])
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
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
    
    func fetchUsdaNutrients(for ndbno: String, completion: @escaping (Response<[Nutrient]>) -> ()) {
        let url = self.url(with: usdaBaseUrl, pathComponents: ["nutrients"])
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = nutrients.map { URLQueryItem(name: "nutrients", value: $0) } + [URLQueryItem(name: "api_key", value: usdaAPIKey), URLQueryItem(name: "ndbno", value: ndbno)]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(ndbno)")
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
                let usdaNutrients = try JSONDecoder().decode(UsdaNutrient.self, from: data)
                if let nutrients = usdaNutrients.report.foods.first?.nutrients {
                    completion(Response.success(nutrients))
                } else {
                    completion(Response.error(NSError()))
                }
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
                NSLog("Error with FETCH urlRequest: \(error)")
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
    
    private func post<Resource: Codable>(with url: URL, requestBody: Dictionary<String, Any?>, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = requestBody
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) //encoder.encode(requestBody)
            urlRequest.httpBody = jsonData
        } catch {
            NSLog("Failed to encode foods: \(error)")
            completion(Response.error(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with POST urlRequest: \(error)")
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
    
    private func delete<Resource: Codable>(with url: URL, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with DELETE urlRequest: \(error)")
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
