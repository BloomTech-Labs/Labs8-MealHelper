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
    
    func changeZip(with userId: Int, newZip: Int, password: String, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["zip", "\(userId)"])
        let newUserDetails = ["zip": newZip, "password": password] as [String: Any]
        put(with: url, requestBody: newUserDetails, completion: completion)
    }
    
    func changeZip(with userId: Int, newEmail: String, password: String, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["email", "\(userId)"])
        let newUserDetails = ["email": newEmail, "password": password] as [String: Any]
        put(with: url, requestBody: newUserDetails, completion: completion)
    }
    
    func changePassword(with userId: Int, newPassword: String, oldPassword: String, completion: @escaping (Response<String>) -> ()) {
        let url = self.url(with: baseUrl, pathComponents: ["password", "\(userId)"])
        let newUserDetails = ["newpassword": newPassword, "oldpassword": oldPassword] as [String: Any]
        put(with: url, requestBody: newUserDetails, completion: completion)
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
    
    func uploadAlarm(time: String, note: String, userId: Int, timestamp: String, completion: @escaping (Response<[Alarm]>) -> ()) {
        let alarm = ["alarm": time, "label": note, "timestamp": timestamp] as [String: Any]
        let url = self.url(with: baseUrl, pathComponents: ["alarms", "\(userId)"])
        post(with: url, requestBody: alarm, completion: completion)
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
