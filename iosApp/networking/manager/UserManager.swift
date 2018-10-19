//
//  NetworkManager.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 24/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct UserManager {
    static let environment : NetworkEnvironment = .production
    //static let environment : NetworkEnvironment = .qa
    //static let MovieAPIKey = ""
    let router = Router<UserEndPoints>()
    
    func sigunUp(body: [String:String], completion: @escaping (_ user: User?,_ error: String?)->()){
        
        router.request(.signUp(body: body)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        do {
                            let apiResponse = try JSONDecoder().decode(User.self, from: responseData)
                            completion(User(id: apiResponse.id, email: apiResponse.email, name: apiResponse.name, description: apiResponse.description, pictureUrl: apiResponse.pictureUrl),nil)
                        }catch {
                            print(error)
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
            }
        }
    }
    
    func login(body: [String:String], completion: @escaping (_ user: User?,_ error: String?)->()){
        
        router.request(.login(body: body)) { data, response, error in
        
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    if let authToken = response.allHeaderFields["Auth"] as? String {
                        print("Token: " + authToken)
                        let saveSuccessful: Bool = KeychainWrapper.standard.set(authToken, forKey: "userToken")
                    }
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(User.self, from: responseData)
                        userRepository = User(id: apiResponse.id, email: apiResponse.email, name: apiResponse.name, description: apiResponse.description, pictureUrl: apiResponse.pictureUrl)
                        
                        completion(userRepository, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func userEvents(token: [String:String], completion: @escaping (_ events: [Event]?,_ error: String?)->()){
        
        router.request(.userEvents(userToken: token)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("Data:")
                    print(data)
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print("Response data:")
                        print(responseData)
                        let apiResponse = try JSONDecoder().decode(EventApiResponse.self, from: responseData)
                        completion(apiResponse.events,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
    func signUpEvent(token: [String:String], code: String, completion: @escaping (_ events: [Event]?,_ error: String?)->()){
        print("In Sign Up event")
        router.request(.signUpEvent(userToken: token, code: code) ) { data, response, error in
            print("Request Done")
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    print("Success")
                    self.userEvents(token: token) { (events, error) in
                        print("Success 2")
                        completion(events,error)
                    }
                case .failure(let networkFailureError):
                    print("Error")
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
    func editProfile(token: [String:String], body: [String:String], completion: @escaping (_ user: User?,_ error: String?)->()){
        
        router.request(.update(userToken: token, body: body)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(User.self, from: responseData)
                        userRepository = User(id: apiResponse.id, email: apiResponse.email, name: apiResponse.name, description: apiResponse.description, pictureUrl: apiResponse.pictureUrl)
                        
                        completion(userRepository, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
