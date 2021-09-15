//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 02/09/21.
//

import Foundation

struct PhotoStruct: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
