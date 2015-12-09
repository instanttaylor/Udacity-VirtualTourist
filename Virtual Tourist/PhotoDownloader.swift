//
//  PhotoDownloader.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 12/2/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import CoreData

class PhotoDownloader {
    
    var pin: Pin!
    
    init(pin: Pin) {
        self.pin = pin
    }
    
    func getPhotos() {
        
        Flickr().getPhotosFromLocation(pin.latitude, long: pin.longitude) { results, error in
            if error != nil {
                print(error)
                return
            }
            guard let all = results["photos"] as? NSDictionary else {return}
            guard let photos = all["photo"] as? NSArray else {return}

            photos.forEach {
                print($0)
                guard let id = $0["id"] as? String else {
                    print("no id")
                    return}
                guard let owner = $0["owner"] as? String else {print("no id")
                    return}
                guard let title = $0["title"] as? String else {print("no title")
                    return}
                guard let secret = $0["secret"] as? String else {print("no secret")
                    return}
                guard let server = $0["server"] as? String else {print("no server")
                    return}
                guard let farm = $0["farm"] as? Int else {
                    print("no farm")
                    return}
                
                let photo = Photo(id: id, owner: owner, title: title, pin: self.pin, farm: farm, secret: secret, server: server, context: self.sharedContext)
                print(photo)
                
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
}