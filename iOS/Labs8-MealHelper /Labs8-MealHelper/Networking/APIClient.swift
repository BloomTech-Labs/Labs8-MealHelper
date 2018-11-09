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
    
        let url = URL(string: "https://8b7e18db.ngrok.io")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(userCredentials)
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
            
//            completion(Response.success(1))
            guard let data = data else {
                NSLog("No data returned")
                completion(Response.error(NSError()))
                return
            }
            
//            Doesn't return a JSON...
            do {
                let userId = try JSONDecoder().decode(Int.self, from: data)
                completion(Response.success(userId))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
    }
}
