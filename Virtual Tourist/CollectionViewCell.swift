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
    
    @IBOutlet weak var imageView: UIImageView!
    
    func updateUI() {
        guard let photo = photo else {return}
        let string = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        guard let url = NSURL(string: string) else {return}
        guard let data = NSData(contentsOfURL: url) else {return}
        
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.image = UIImage(data: data)
        }
    }
    
}
