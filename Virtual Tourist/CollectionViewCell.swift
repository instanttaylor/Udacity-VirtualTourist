//
//  CollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/25/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var photo: Photo? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    func updateUI() {
        var photoImage = UIImage(named: "")
        
        if photo?.photoPath == nil || photo?.photoPath == "" {
            print("photopath is bad: \(photo?.photoPath)")
            photoImage = UIImage(named: "noImage")
        } else if photo?.photoImage != nil {
            print("photo path isn't nil so setting it: \(photo?.photoImage)")
            photoImage = photo?.photoImage
        } else {
            print("i'm downloading a photo")
//            this returns a photo when it's downloaded
            
            let qos = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qos, 0)
            
            dispatch_async(backgroundQueue) {
                let newPhoto = PhotoDownloader().downloadImageForPhoto(self.photo!)
                //            this uses the set method to store the image in a cache
                print("here's the new photo: \(newPhoto)")
                self.photo?.photoImage = newPhoto
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = newPhoto
                    print("adding image in background queue")
                }
            }
            
        }
        activityIndicator.stopAnimating()
        imageView.image = photoImage
    }
}
