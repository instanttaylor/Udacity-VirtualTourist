//
//  PinAnnotation.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 12/9/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: MKPointAnnotation {
    
    var pinID: Int!
    
    init(pinID: Int) {
        self.pinID = pinID
    }
    
}