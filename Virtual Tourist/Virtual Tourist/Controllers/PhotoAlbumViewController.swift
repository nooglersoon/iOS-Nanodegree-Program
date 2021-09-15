//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 30/08/21.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var dataController = DataController(modelName: "VirtualTouristModel")
    var pin: Pin!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    var pinCoordinate: CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard pin != nil else {
            
            print("Invalid Pin Annotation")
            alertView(title: "Error, Invalid Pin Annotation Location or Fetched Failed", message: "Try Again")
            return
        }
        
        setUpRegion(pin: pin)
        setUpCollectionView(collectionView: photoCollectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFetchedResultsController()
        downloadNewAlbum()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func alertView(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // Setup the collectionview layout
    
    func setUpCollectionView(collectionView: UICollectionView){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
    }
    
    // Setup the mapview preview focused on selected pin
    
    func setUpRegion(pin: Pin){
        
        let regionPin = PinAnnotation(pin: pin)
        mapView.addAnnotation(regionPin)
        let region = mapView.regionThatFits(MKCoordinateRegion(center: regionPin.coordinate, latitudinalMeters: 600, longitudinalMeters: 600))
        self.mapView.setRegion(region, animated: true)
        
    }
    
    // Preparing Fetch Data
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        
        if let pin = pin {
            let predicate = NSPredicate(format: "pin = %@", pin)
            fetchRequest.predicate = predicate
            
            print("\(pin.latitude) \(pin.longitude)")
        }
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "photo")
        fetchedResultsController.delegate = self
        
        print(fetchedResultsController.cacheName!)
        print("fetched object: ", fetchedResultsController.fetchedObjects?.count ?? 0)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: Any) {
        
        guard let photoObjects = fetchedResultsController.fetchedObjects else {
            
            print("Photo object is not fetched")
            return
            
            
        }
        
        print(photoObjects)
        
        for image in photoObjects {
            dataController.viewContext.delete(image)
            print("Photo deleted")
            do {
                try dataController.viewContext.save()
                
            } catch {
                print("Unable to delete images")
            }
        }
        
        downloadNewAlbum()
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func downloadNewAlbum(){
        
        activityIndicator.startAnimating()
        
        guard (fetchedResultsController.fetchedObjects?.isEmpty)! else {
            activityIndicator.stopAnimating()
            print("Image Data has already downloaded")
            return
        }
        
        FlickrClient.getPhotosId(latitude: pin.latitude, longitude: pin.longitude) { [self] album, error in
            
            if error == nil {
                
                for photo in album {
                    
                    let photoToSave = Photo(context: dataController.viewContext)
                    
                    photoToSave.pin = pin
                    photoToSave.createdDate = Date()
                    photoToSave.photoImage = nil
                    photoToSave.photoURL = FlickrClient.Endpoints.downloadPhoto(photo.server, photo.id, photo.secret).url
                    
                    do {
                        print("Photo saved")
                        try self.dataController.viewContext.save()
                        
                    } catch {
                        debugPrint("error in saving image data: \(error.localizedDescription)")
                    }
                    
                }
                
                self.activityIndicator.stopAnimating()
                
            } else {
                print("Error fetching URL data")
                self.alertView(title: "Error", message: "Error Fetching URL Data!")
            }
            
        }
        
    }
    
}
