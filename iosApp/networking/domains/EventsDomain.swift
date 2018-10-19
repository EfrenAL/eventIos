//
//  EventsDomain.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 01/10/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation


public enum EventsEndPoints {
    case getPeopleEvent(token: [String:String], eventId: String)
}

extension EventsEndPoints: EndPointType{
    
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
        case .getPeopleEvent(_, let eventId):
            return "event/user/\(eventId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getPeopleEvent:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getPeopleEvent(let userToken, _):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .jsonEncoding ,
                                                urlParameters: nil,
                                                additionHeaders: userToken)
        }
    }
    
    var header: HTTPHeaders? {
        return nil
    }
}
