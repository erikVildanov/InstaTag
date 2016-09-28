//
//  Entity+CoreDataClass.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 27.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import Foundation
import CoreData


public class Fevarites: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fevarites> {
        return NSFetchRequest<Fevarites>(entityName: "Fevarites");
    }
    
    @NSManaged public var image: NSData?
    @NSManaged public var comment: String?
}
