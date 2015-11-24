//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/23/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {
    
    @NSManaged var id: Int64
    @NSManaged var owner: Int64
    @NSManaged var title: String
    @NSManaged var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: Int64, owner: Int64, title: String, pin: Pin, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.owner = owner
        self.title = title
        self.pin = pin
        
    }
}

