//
//  UserModel.swift
//  iosApp
//
//  Created by Efren Alvarez Lamolda on 24/09/2018.
//  Copyright © 2018 Efren Alvarez Lamolda. All rights reserved.
//

import Foundation

struct UserApiResponse {
    let user: User
}

struct UsersApiResponse {
    let users: [User]
}

extension UsersApiResponse: Decodable {
    private enum UsersApiResponseCodingKeys: String, CodingKey {
        case users
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsersApiResponseCodingKeys.self)
        users = try container.decode([User].self, forKey: .users)
    }
}

struct User {
    let id: Int
    let email: String
    let name: String
    var description: String?
    var pictureUrl: String?
}

extension User: Decodable {
    
    enum UserCodingKeys: String, CodingKey {
        case id
        case email
        case name
        case description
        case pictureUrl
        //case rating = "vote_average"
    }
    
    
    init(from decoder: Decoder) throws {
        let userContainer = try decoder.container(keyedBy: UserCodingKeys.self)
        
        id = try userContainer.decode(Int.self, forKey: .id)
        email = try userContainer.decode(String.self, forKey: .email)
        name = try userContainer.decode(String.self, forKey: .name)
        description = try userContainer.decodeIfPresent(String.self, forKey: .description)
        pictureUrl = try userContainer.decodeIfPresent(String.self, forKey: .pictureUrl)
    }
}
