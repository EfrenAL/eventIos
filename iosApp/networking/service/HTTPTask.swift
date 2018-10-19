//
//  HTTPTask.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 22/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
    
}
