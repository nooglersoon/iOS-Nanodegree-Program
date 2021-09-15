//
//  PinExtension.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 04/09/21.
//

import Foundation
import CoreData

extension Pin {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdDate = Date()
    }
    
}
