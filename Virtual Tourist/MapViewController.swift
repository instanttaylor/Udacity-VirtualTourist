//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 11/23/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLongPress()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        retrievePreviousMapCoords()
        setAllSavedPins()
    }
    
    func addLongPress() {
        let lp = UILongPressGestureRecognizer(target: self, action: "addPin:")
        lp.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(lp)
    }
    
    func addPin(gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            let touchLocation = gesture.locationInView(gesture.view?.window)
            let coords = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            mapView.addAnnotation(annotation)
            let _ = Pin(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude, context: sharedContext)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    func setAllSavedPins() {
        let pins = fetchAllPins()
        pins.forEach {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    func storeCurrentMapCoords() {
        
        let dictionary = [
            "latitude":mapView.region.center.latitude,
            "longitude":mapView.region.center.longitude,
            "latspan":mapView.region.span.latitudeDelta,
            "longspan":mapView.region.span.longitudeDelta
        ]
        
        NSUserDefaults.standardUserDefaults().setObject(dictionary, forKey: "coords")
    }
    
    func retrievePreviousMapCoords() {
        guard let dictionary = NSUserDefaults.standardUserDefaults().objectForKey("coords") else {return}
        
        let lat = dictionary["latitude"] as! CLLocationDegrees
        let long = dictionary["longitude"] as! CLLocationDegrees
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let latspan = dictionary["latspan"] as! CLLocationDegrees
        let longspan = dictionary["longspan"] as! CLLocationDegrees
        let span = MKCoordinateSpan(latitudeDelta: latspan, longitudeDelta: longspan)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: false)
        
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        storeCurrentMapCoords()
    }
    
//    CORE DATA
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch {
            print("error in fetch")
            return [Pin]()
        }
    }
}
