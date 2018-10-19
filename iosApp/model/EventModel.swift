//
//  EventModel.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 25/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation

struct EventApiResponse {
    let id: Int
    let email: String
    let name: String
    var description: String?
    var pictureUrl: String?
    let events: [Event]
}

extension EventApiResponse: Decodable {
 
 private enum EventApiResponseCodingKeys: String, CodingKey {
    case events    
    case id
    case email
    case name
    case description
    case pictureUrl
 }
 
 init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: EventApiResponseCodingKeys.self)
    
    id = try container.decode(Int.self, forKey: .id)
    email = try container.decode(String.self, forKey: .email)
    name = try container.decode(String.self, forKey: .name)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    pictureUrl = try container.decodeIfPresent(String.self, forKey: .pictureUrl)
    
     events = try container.decode([Event].self, forKey: .events)
 }
}

struct Event {
    let id: Int
    let name: String
    let description: String
    let code: String
    let postcode: String
    let street: String
    let city: String
    let country: String
    let pictureUrl: String
    let thumbnailUrl: String
    let webUrl: String
}

extension Event: Decodable {
    
    enum EventCodingKeys: String, CodingKey {
        case id
        case name
        case description
        case code
        case postcode
        case street
        case city
        case country
        case pictureUrl
        case thumbnailUrl
        case webUrl
    }
    
    
    init(from decoder: Decoder) throws {
        let eventContainer = try decoder.container(keyedBy: EventCodingKeys.self)
        id = try eventContainer.decode(Int.self, forKey: .id)
        name = try eventContainer.decode(String.self, forKey: .name)
        description = try eventContainer.decode(String.self, forKey: .description)
        code = try eventContainer.decode(String.self, forKey: .code)
        postcode = try eventContainer.decode(String.self, forKey: .postcode)
        street = try eventContainer.decode(String.self, forKey: .street)
        city = try eventContainer.decode(String.self, forKey: .city)
        country = try eventContainer.decode(String.self, forKey: .country)
        pictureUrl = try eventContainer.decode(String.self, forKey: .pictureUrl)
        thumbnailUrl = try eventContainer.decode(String.self, forKey: .thumbnailUrl)
        webUrl = try eventContainer.decode(String.self, forKey: .webUrl)
    }
}
