//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 30/08/21.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class TravelLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    var dataController: DataController!
    var pin: Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    // Function to set up the initial condition of the mapview
    func setUpMapView(){
        
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTapGesture(gestureRecognizer:)))
        mapView.addGestureRecognizer(longTapGesture)
        
    }
    
    // Function to handle Long Tap Gesture on The Map for Creating an Annotation.
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            print("Tapped at latitude: \(locationCoordinate.latitude) and longitude: \(locationCoordinate.longitude)")
            
            // Geocoding an address
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)) { placemark, error in
                
                guard let placemark = placemark else {
                    return
                }
                
                self.savePinAnnotation(placemark: placemark[0], coordinate: locationCoordinate)
                
            }
        }
        
        if gestureRecognizer.state != UIGestureRecognizer.State.began {
            return
        }
        
    }
    
    func savePinAnnotation(placemark: CLPlacemark, coordinate: CLLocationCoordinate2D){
        
        // Create Map Annotation
        
        let address = placemark.thoroughfare ?? "Unamed Street"
        
        pin = Pin(context: dataController.viewContext)
        
        if let pin = pin {
            
            pin.createdDate = Date()
            pin.address = address
            pin.latitude = coordinate.latitude
            pin.longitude = coordinate.longitude
            try? dataController.viewContext.save()
            let pinAnnotation = PinAnnotation(pin: pin)
            
            mapView.addAnnotation(pinAnnotation)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let pinAnnotation: PinAnnotation = sender as! PinAnnotation
        
        let navigationVC = segue.destination as! UINavigationController
        let photoAlbumVC = navigationVC.topViewController as! PhotoAlbumViewController
        
        photoAlbumVC.dataController = dataController
        photoAlbumVC.pin = pinAnnotation.pin
        
        
    }
    
    
}

// MARK: - Delegate for MapView

extension TravelLocationMapViewController: MKMapViewDelegate {
    
    // Set custom view for annotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
    
        let pinAnnotation = annotation as! PinAnnotation
        pinAnnotation.title = pinAnnotation.pin.address
   
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin!.canShowCallout = true
            pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        
        return pin
        
    }
    
    // Set annotation callout callback when tapped
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        guard let _ = view.annotation else {
                return
            }
        
        if let annotation = view.annotation as? MKPointAnnotation {
            do {
                let predicate = NSPredicate(format: "longitude = %@ AND latitude = %@", argumentArray: [annotation.coordinate.longitude, annotation.coordinate.latitude])
                let pindata = try dataController.fetchLocation(predicate)!
                let annotationPin = PinAnnotation(pin: pindata)
                self.performSegue(withIdentifier: "goToPhotoAlbum", sender: annotationPin)
            } catch {
                print("There was an error!!")
            }
        }
        
    }
    
    
    
    
}

// MARK: - Delegate for FetchResultsController

extension TravelLocationMapViewController: NSFetchedResultsControllerDelegate{
    
    func setupFetchedResultsController(){
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // Fetch request for the Pin Entity and set the sort desrtiptor
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self
        
        dataController.viewContext.perform {
            
            do {
                
                let pins = try self.dataController.viewContext.fetch(fetchRequest)
                self.mapView.addAnnotations(pins.map { pin in
                    PinAnnotation(pin: pin)
                    
                })
                
            } catch {
                print("Error fetching Pins: \(error)")
            }
            
        }
        
        
    }
    
    
    
}

// MARK: - Delegate for Gesture Recognizer

extension TravelLocationMapViewController: UIGestureRecognizerDelegate {
    
    
    
}
