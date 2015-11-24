//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/23/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import CoreData

class Pin: NSManagedObject {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(lat: Double, long: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.latitude = lat
        self.longitude = long
        
    }
}
