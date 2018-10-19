//
//  EndPointType.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 22/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: HTTPHeaders? { get }
}
