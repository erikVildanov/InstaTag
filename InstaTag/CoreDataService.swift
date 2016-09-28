//
//  CoreDataService.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 27.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import CoreData

class CoreDataService {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func createNewFevarites(_ comment: String, image: NSData) -> Fevarites {
        
        let newFevarites = NSEntityDescription.insertNewObject(forEntityName: "Fevarites", into: context) as! Fevarites
        
        newFevarites.comment = comment
        newFevarites.image = image
        
        return newFevarites
    }
    
    func getByIdFevarites(_ id: NSManagedObjectID) -> Fevarites {
        return context.object(with: id) as! Fevarites
    }
    
    func getAllFevarites() -> [Fevarites]{
        return getFevarites(withPredicate: NSPredicate(value:true))
    }
    
    func getFevarites(withPredicate queryPredicate: NSPredicate) -> [Fevarites]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fevarites")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest)
            return response as! [Fevarites]
            
        } catch let error as NSError {
            print(error)
            return [Fevarites]()
        }
    }
    
    func deleteFevarites(_ id: NSManagedObjectID){
        
            context.delete(getByIdFevarites(id))
        
    }
    
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
