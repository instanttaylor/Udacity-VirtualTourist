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

class PhotosViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var button: UIButton!
    
    var coordinates: CLLocationCoordinate2D?
    var pin: Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMapView()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchedResultsController.delegate = self
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
        generateNewCollection()
    }
    
    func generateNewCollection() {
        pin!.deletePhotos()

//        guard let pinToDownload = self.pin else { return }
//        PhotoDownloader().getPhotos(pinToDownload)
    }

    
//    CORE DATA
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
//    FETCHED RESULTS CONTROLLER DELEGATE METHODS
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        don't need this one for collection view
        print("i'm in will change thing")
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        no section data for this collection view
        print("i'm in section thing")
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            collectionView.deleteItemsAtIndexPaths([indexPath!])
        case .Insert:
            collectionView.insertItemsAtIndexPaths([newIndexPath!])
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        print("i'm in did change")
        self.collectionView.reloadData()
    }
    
    func deleteAllPhotos() {
        guard let pin = pin else { return }
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        do {
            let photosForPin = try sharedContext.executeFetchRequest(fetchRequest) as! [Photo]
            for entity in photosForPin {
                self.sharedContext.deleteObject(entity)
            }
        } catch let error as NSError {
            print("Error in fetchAllPhotos(): \(error)")
            return
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.photo = photo
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        sharedContext.deleteObject(photo)
        CoreDataStackManager.sharedInstance().saveContext()
        
    }
}
