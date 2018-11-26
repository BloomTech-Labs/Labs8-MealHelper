//
//  APIClient.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    
    //Gonna create a general fetch function we can use for all GET requests
//    func fetch(items: <Resource: Codable>, httpMethod: HTTPMethod, endpoint: )
    
    func login(with email: String, password: String, completion: @escaping (Response<UserId>) -> ()){
        let url = URL(string: "https://labs8-meal-helper.herokuapp.com/login/")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let loginDetails = ["email": email, "password": password]
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let loginJson = try encoder.encode(loginDetails)
            urlRequest.httpBody = loginJson
        } catch {
            NSLog("Failed to encode user credentials: \(error)")
            completion(Response.error(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with urlReqeust: \(error)")
                completion(Response.error(error))
                return
            }
            
            guard let data = data else {
                NSLog("Error unwrapping data")
                completion(Response.error(NSError()))
                return
            }
            
            do {
            
                let user = try JSONDecoder().decode(UserId.self, from: data)
                completion(Response.success(user))
    
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
            
//            if let httpResponse = res as? HTTPURLResponse {
//                print(httpResponse.statusCode)
//                switch httpResponse.statusCode {
//                case 200:
//                    //successful
//                    completion(Response.success(email))
//                case 500:
//                    //error
//                    completion(Response.error(NSError()))
//                default:
//                    completion(Response.error(NSError()))
//                }
//            }
        }.resume()
    }
    
    func register(with userCredentials: User, completion: @escaping (Response<UserId>) -> ()) {
    
        let url = URL(string: "https://labs8-meal-helper.herokuapp.com/register/")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let userJson = try encoder.encode(userCredentials)
            urlRequest.httpBody = userJson
        } catch {
            NSLog("Failed to encode user credentials: \(error)")
            completion(Response.error(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
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
                let user = try JSONDecoder().decode(UserId.self, from: data)
                completion(Response.success(user))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
    }
}


struct UserId: Decodable {
    var id: Int?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case token
    }
}
