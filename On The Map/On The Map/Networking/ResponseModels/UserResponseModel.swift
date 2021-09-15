//
//  UserProfile.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 24/08/21.
//

import Foundation

struct UserResponseModel: Codable {
    let user: UserData
}

struct UserData: Codable {
    
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
