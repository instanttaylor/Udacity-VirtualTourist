//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/25/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import MapKit

class PhotosViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var button: UIButton!
    
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getPhotos()
        loadMapView()
    }
    
    func loadMapView() {
        if let coords = coordinates {
            let point = CLLocationCoordinate2DMake(coords.latitude, coords.longitude)
            let adjustedRegion = MKCoordinateRegionMakeWithDistance(point, 1000, 1000)
            mapView.setRegion(adjustedRegion, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func getPhotos() {
        print("getting photos for \(coordinates)")
    }
    
    @IBAction func newCollectionTapped(sender: AnyObject) {
    }
}
