//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/25/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var button: UIButton!
    
    var coordinates: CLLocationCoordinate2D?
    var pin: Pin?
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMapView()
        collectionView.delegate = self
        collectionView.dataSource = self
        photos = fetchAllPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView.reloadData()
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
    
    @IBAction func newCollectionTapped(sender: AnyObject) {
    }
    
//    CORE DATA
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
            
    func fetchAllPhotos() -> [Photo] {
        guard let pin = pin else { return [Photo]() }
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Photo]
        } catch let error as NSError {
            print("Error in fetchAllEvents(): \(error)")
            return [Photo]()
        }
    }
    
    
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.photo = photos[indexPath.item]
        return cell
    }
}
