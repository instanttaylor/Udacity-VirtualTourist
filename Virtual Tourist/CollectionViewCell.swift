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
        guard let photoToDownload = photo else {return}
        
        let qos = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qos, 0)
        
        dispatch_async(backgroundQueue) {
            guard let data = PhotoDownloader().downloadImageForPhoto(photoToDownload) else {return}
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.imageView.image = UIImage(data: data)
            }
        }
    }
}
