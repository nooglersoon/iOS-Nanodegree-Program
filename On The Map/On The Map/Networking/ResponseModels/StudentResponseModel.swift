//
//  Students.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import Foundation

struct StudentResponseModel: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
}
