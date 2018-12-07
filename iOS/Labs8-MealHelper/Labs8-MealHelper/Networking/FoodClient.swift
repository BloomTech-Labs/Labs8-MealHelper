//
//  FoodClient.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 15.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class FoodClient: GenericAPIClient {
    
    static let shared = FoodClient()
    
    var nutrients = ["208", "205", "204", "203", "269"]
    
    let usdaBaseUrl: URL = URL(string: "https://api.nal.usda.gov/ndb/")!
    let usdaAPIKey = "c24xU3JZJhbrgnquXUNlyAGXcysBibSmESbE3Nl6"
    let baseUrl: URL = URL(string: "https://labs8-meal-helper.herokuapp.com/")!
    var userId = String(UserDefaults().loggedInUserId())
    
    // MARK: - Meal Helper
    
    func fetchMeals(completion: @escaping (Response<[Meal]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", userId, "meals"])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchRecipes(completion: @escaping (Response<[Recipe]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", "user", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchIngredients(completion: @escaping (Response<[Ingredient]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchIngredients(with recipeId: Int, completion: @escaping (Response<[Ingredient]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        
        fetch(from: url, completion: completion)
        
    }
    
    func fetchNutrients(with ingredientId: Int, completion: @escaping (Response<[Nutrient]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", String(ingredientId)])
        
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
    
    func postRecipe(name: String, calories: Int, servings: Int, completion: @escaping (Response<[Recipe]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", userId])
        let reqBody = ["name": name, "calories": calories, "servings": servings] as [String : Any]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postIngredient(name: String, ndbno: Int?, recipeId: Int?, completion: @escaping (Response<[Ingredient]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", userId])
        let reqBody = ["name": name as Any, "ndbno": ndbno as Any, "recipe_id": recipeId as Any] as [String : Any]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postNutrient(_ nutrient: Nutrient, ingredientId: Int, completion: @escaping (Response<TempType>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", userId])
        let reqBody = ["nutrient": nutrient.name, "nutrient_id": Int(nutrient.identifier)!, "unit": nutrient.unit, "value": Int(Double(nutrient.value)!), "ingredients_id": ingredientId] as [String : Any]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func postNutrient(nutrientId: String, ingredientId: String, completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", ingredientId])
        let reqBody = ["id": nutrientId]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func putIngredient(withId ingredientId: Int, nutrientIds: [Int], completion: @escaping (Response<Int>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["nutrients", "ingredients", String(ingredientId)])
        let reqBody = ["ids": nutrientIds]
        
        post(with: url, requestBody: reqBody, completion: completion)
        
    }
    
    func deleteMeal(withId id: String, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", id, "meals"])
        
        delete(with: url, completion: completion)
        
    }
    
    func deleteRecipe(withId id: String, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["recipe", id])
        
        delete(with: url, completion: completion)
        
    }
    
    func deleteIngredient(withId id: String, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["ingredients", id])
        
        delete(with: url, completion: completion)
        
    }
    
    func deleteNutrient(withId id: String, completion: @escaping (Response<String>) -> ()) {
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
    
    func fetchUsdaNutrients(for ndbno: Int, completion: @escaping (Response<([Nutrient], String)>) -> ()) {
        let url = self.url(with: usdaBaseUrl, pathComponents: ["nutrients"])
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = nutrients.map { URLQueryItem(name: "nutrients", value: $0) } + [URLQueryItem(name: "api_key", value: usdaAPIKey), URLQueryItem(name: "ndbno", value: String(ndbno))]
        
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
                if let ingredient = usdaNutrients.report.foods.first, let ingredMeasure = ingredient.measure {
                    completion(Response.success((ingredient.nutrients, ingredMeasure)))
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
    
    
    
    // MARK: - Private methods
    
    private func convertToIngredient(_ usdaIngredients: [UsdaIngredients.Item.UsdaIngredient]) -> [Ingredient] {
        return usdaIngredients.compactMap { nutrient in
            guard let ndbIdInt = Int(nutrient.ndbId) else {
                NSLog("USDA ingredient didn't contain valid ndbId: \(nutrient.ndbId)")
                return nil
            }
            return Ingredient(name: nutrient.name, nbdId: ndbIdInt)
        }
    }
    
}
