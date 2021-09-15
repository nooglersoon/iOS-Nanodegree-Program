//
//  AuthRequest.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 23/08/21.
//

import Foundation

struct AuthRequest: Codable {
    
    let udacity: [String:String]
    
    let email: String
    let password: String
    
}
