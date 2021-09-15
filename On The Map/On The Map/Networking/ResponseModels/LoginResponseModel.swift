//
//  LoginResponse.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 23/08/21.
//

import Foundation


struct LoginResponseModel: Codable {
    
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
    
    
}

struct Account: Codable {
    
    let registered: Bool
    let key: String
    
}

struct Session: Codable {
    
    let id: String
    let expiration: String
    
}
