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
    
    func fetchAlarms(userId: Int, completion: @escaping (Response<[Alarm]>) -> ()) {
        let url = URL(string: "https://labs8-meal-helper.herokuapp.com/alarms/\(userId)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
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
                let alarms = try JSONDecoder().decode([Alarm].self, from: data)
                completion(Response.success(alarms))
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
    }
    
    func uploadAlarm(time: String, note: String, userId: Int, timestamp: String, completion: @escaping (Response<Alarm>) -> ()) {
        let url = URL(string: "https://labs8-meal-helper.herokuapp.com/alarms/\(userId)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            let alarm = ["alarm": time, "label": note, "timestamp": timestamp]
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let alarmJson = try encoder.encode(alarm)
            urlRequest.httpBody = alarmJson
            
        } catch {
            NSLog("Error encoding alarm: \(error)")
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
                let alarms = try JSONDecoder().decode([Alarm].self, from: data)
                let sortedAlarms = alarms.sorted(by: { $0.timestamp > $1.timestamp })
                let createdAlarm = sortedAlarms.first
                completion(Response.success(createdAlarm!))
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
        }.resume()
        
    }
    
    func fetchMeals(completion: @escaping (Response<[Meal]>) -> ()) {
        let url = URL(string: "https://labs8-meal-helper.herokuapp.com/users/1/meals/")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            
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
                
                let meal = try JSONDecoder().decode([Meal].self, from: data)
                completion(Response.success(meal))
                
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(Response.error(error))
                return
            }
            
        }.resume()
    }
    
    
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
