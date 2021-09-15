//
//  PhotoExtension.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 05/09/21.
//

import Foundation
import CoreData

extension Photo {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        createdDate = Date()
        
        
    }
    
}
