//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 04/09/21.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    // Variable to access the context
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    // MARK: Load The Store
    
    func load(completion: (()->Void)? = nil) {
        
        persistentContainer.loadPersistentStores { storeDescription, error in
        
            guard error == nil else {
                
                fatalError(error!.localizedDescription)
                
            }
            
            self.autoSaving()
            completion?()
            
        
        }

    }
    
    // MARK: Autosaving
    
    func autoSaving(interval:TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaving(interval: interval)
        }
    }
    
    
    
}

extension DataController {
    func fetchLocation(_ predicate: NSPredicate, sorting: NSSortDescriptor? = nil) throws -> Pin? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let location = (try viewContext.fetch(fr) as! [Pin]).first else {
            return nil
        }
        return location
    }
    
    func fetchAllLocation() throws -> [Pin]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        guard let pin = try viewContext.fetch(fr) as? [Pin] else {
            return nil
        }
        return pin
    }
    
    func fetchAllPhoto(_ predicate: NSPredicate? = nil, sorting: NSSortDescriptor? = nil) throws -> [Photo]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let allPhoto = try viewContext.fetch(fr) as? [Photo] else {
            return nil
        }
        return allPhoto
    }
}
