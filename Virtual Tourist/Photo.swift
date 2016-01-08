//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/23/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var owner: String
    @NSManaged var title: String
    @NSManaged var pin: Pin
    @NSManaged var thing: String?
    @NSManaged var farm: Int
    @NSManaged var secret: String
    @NSManaged var server: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: String, owner: String, title: String, pin: Pin, farm: Int, secret: String, server: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.owner = owner
        self.title = title
        self.pin = pin
        self.farm = farm
        self.secret = secret
        self.server = server
        self.thing = "Testing out data migration"
        
    }
    
    var photoPath: String {
        return "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
    }
    
    var photoImage: UIImage? {
        get {
            return Flickr.Caches.imageCache.imageWithIdentifier(photoPath)
        }
        
        set {
            Flickr.Caches.imageCache.storeImage(newValue, withIdentifier: photoPath)
        }
    }
}

