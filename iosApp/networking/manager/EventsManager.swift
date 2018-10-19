//
//  EventsManager.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 01/10/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation


struct EventsManager {
    static let environment : NetworkEnvironment = .production
    //static let environment : NetworkEnvironment = .qa
    let router = Router<EventsEndPoints>()
    
    func getPeopleEvent(token: [String:String], eventId: String, completion: @escaping (_ users: [User]?,_ error: String?)->()){

        router.request(.getPeopleEvent(token: token, eventId: eventId) ) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    do {
                        print("Response data:")
                        print(response)
                        let apiResponse = try JSONDecoder().decode(UsersApiResponse.self, from: data!)
                        peopleRepository = apiResponse.users
                        completion(peopleRepository,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }                    
                case .failure(let networkFailureError):
                    print("Error")
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
