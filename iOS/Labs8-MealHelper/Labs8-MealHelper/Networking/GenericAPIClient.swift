//
//  GenericAPIClient.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 05/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class GenericAPIClient {
    
    func url(with baseUrl: URL, pathComponents: [String]) -> URL {
        var url = baseUrl
        pathComponents.forEach { url.appendPathComponent($0) }
        return url
    }
    
    func fetch<Resource: Codable>(from url: URL, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
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
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
                    completion(Response.error(NSError()))
                    return
                }
            }
            
            do {
                let ressource = try JSONDecoder().decode(Resource.self, from: data)
                completion(Response.success(ressource))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
    }
    
    func put(with url: URL, requestBody: Dictionary<String, Any>, completion: @escaping (Response<String>) -> ()) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.put.rawValue
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
        
        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with PUT urlRequest: \(error)")
                completion(Response.error(error))
                return
            }
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
                    completion(Response.error(NSError()))
                    return
                }
            }
            completion(Response.success("Success"))
        }.resume()
    }
    
    func post<Resource: Codable>(with url: URL, requestBody: Dictionary<String, Any>, using session: URLSession = URLSession.shared, completion: @escaping ((Response<Resource>) -> ())) {
        
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
        
        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            
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
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
                    completion(Response.error(NSError()))
                    return
                }
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
    
    func delete(with url: URL, using session: URLSession = URLSession.shared, completion: @escaping ((Response<String>) -> ())) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, res, error) in
            
            if let error = error {
                NSLog("Error with DELETE urlRequest: \(error)")
                completion(Response.error(error))
                return
            }
            
            if let httpResponse = res as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    NSLog("An error code was returned from the http request: \(httpResponse.statusCode)")
                    completion(Response.error(NSError()))
                    return
                }
            }
            completion(Response.success("Success"))
        }.resume()
    }
}
