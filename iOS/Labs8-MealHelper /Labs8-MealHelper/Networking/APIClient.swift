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
    
    func register(with userCredentials: User, completion: @escaping (Response<Int>) -> ()) {
    
        let url = URL(string: "http://localhost:3300/register/")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(userCredentials)
        } catch let error {
            NSLog("Failed to encode user credentials: \(error)")
            completion(Response.error(error))
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError()))
                return
            }
            
            print(data)
            completion(Response.success(1))
            
        }.resume()
    }
}
