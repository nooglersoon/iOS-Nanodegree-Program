//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 02/09/21.
//

import Foundation

struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [PhotoStruct]
}
