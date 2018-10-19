//
//  NetworkError.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 22/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation

public enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFail = "Parameters encoding fail"
    case missingUrl = "Url is nil"    
}
