//
//  UserDomain.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 23/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
}

public enum UserEndPoints {
    case signUp(body: [String:String])
    case login(body: [String:String])
    case socialLogin()
    case update(userToken: [String:String], body: [String:String])
    case signUpEvent(userToken: [String:String], code:String)
    case userEvents(userToken: [String:String])
}


extension UserEndPoints: EndPointType{
    
    var environmentBaseURL : String {
        switch UserManager.environment {
        case .production:
            return "http://bquini-api.herokuapp.com/"
        case .qa:
            return "http://localhost:3000/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
            case .signUp:
                return "user"
            case .login:
                return "user/login"
            case .socialLogin:
                return "/user/facebook"
            case .update:
                return "user"
            case .signUpEvent(_, let code):
                return "user/event/\(code)"
            case .userEvents:
                return "user/event/all"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .login:
            return .post
        case .userEvents:
            return .get
        case .socialLogin:
            return .post
        case .update:
            return .put
        case .signUpEvent:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
            case .signUp(let body):
                return .requestParameters(bodyParameters: body,
                                          bodyEncoding: .jsonEncoding ,
                                          urlParameters: nil)
            case .login(let body):
                return .requestParameters(bodyParameters: body,
                                          bodyEncoding: .jsonEncoding ,
                                          urlParameters: nil)
            case .userEvents(let userToken):
                return .requestParametersAndHeaders(bodyParameters: nil,
                                          bodyEncoding: .jsonEncoding ,
                                          urlParameters: nil,
                                          additionHeaders: userToken)
            case .signUpEvent(let userToken, _):
                return .requestParametersAndHeaders(bodyParameters: nil,
                                                    bodyEncoding: .jsonEncoding ,
                                                    urlParameters: nil,
                                                    additionHeaders: userToken)
            case .update(let userToken, let body):
                return .requestParametersAndHeaders(bodyParameters: body,
                                                    bodyEncoding: .jsonEncoding,
                                                    urlParameters: nil,
                                                    additionHeaders: userToken)
            
            default:
                return .request
        }
    }
    
    var header: HTTPHeaders? {
        return nil
    }
}
