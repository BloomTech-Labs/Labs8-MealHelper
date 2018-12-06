//
//  APIClient.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 08/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class APIClient: GenericAPIClient {
    
    static let shared = APIClient()
    let baseUrl = URL(string: "https://labs8-meal-helper.herokuapp.com")!
    
    
    func deleteUser(with userId: Int, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", "\(userId)"])
        delete(with: url, completion: completion)
    }
    
    func deleteAlarm(with id: Int, userId: Int, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["alarms", "\(id)", "user", "\(userId)"])
        delete(with: url, completion: completion)
    }
    
    func editAlarm(with id: Int, completion: @escaping (Response<Int>) -> ()) {
        let url = URL(string: "https://labs8-meal-helper.herokuapp.com/alarms/\(id)/user/\(String(UserDefaults.standard.loggedInUserId()))")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.put.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            
            if let error = error {
                NSLog("Error editing alarm: \(error)")
                completion(Response.error(error))
                return
            }
            
            completion(Response.success(1))
        }.resume()
    }
    
    func fetchAlarms(userId: Int, completion: @escaping (Response<[Alarm]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["alarms", "\(userId)"])
        fetch(from: url, completion: completion)
    }
    
<<<<<<< HEAD
    func uploadAlarm(time: String, note: String, userId: Int, timestamp: String, completion: @escaping (Response<[Alarm]>) -> ()) {
        let alarm = ["alarm": time, "label": note, "timestamp": timestamp] as [String: Any]
        let url = self.url(with: baseUrl, pathComponents: ["alarms", "\(userId)"])
        post(with: url, requestBody: alarm, completion: completion)
=======
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
        
>>>>>>> 202cf1be0298090106fe744feb8fdd9470c377c5
    }
    
    func fetchMeals(with userId: Int, completion: @escaping (Response<[Meal]>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["users", "\(userId)", "meals"])
        fetch(from: url, completion: completion)
    }

    func login(with email: String, password: String, completion: @escaping (Response<UserId>) -> ()){
        let url = self.url(with: baseUrl, pathComponents: ["login"])
        let loginDetails = ["email": email, "password": password] as [String: Any]
        post(with: url, requestBody: loginDetails, completion: completion)
    }
    
    func register(email: String, password: String, zip: Int, completion: @escaping (Response<UserId>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["register"])
        let userCredentials = ["email": email, "password": password, "zip": zip] as [String: Any]
        post(with: url, requestBody: userCredentials, completion: completion)
    }
}
