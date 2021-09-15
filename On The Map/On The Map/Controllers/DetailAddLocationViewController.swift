//
//  DetailAddLocationViewController.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import UIKit
import MapKit

class DetailAddLocationViewController: UIViewController {
    
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var finishAddLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location: String = ""
    var mediaURL: String = ""
    var newCoordinate: CLLocationCoordinate2D?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishAddLocationButton.setMainStyle()
        setNewCoordinate()
        
        
    }
    
    @IBAction func finishAddLocationTapped(_ sender: Any) {
        
        whilePostingLocation(true)
        
        OTMClient.addUserLocation(location: location, mediaURL: mediaURL, latitude: newCoordinate!.latitude, longitude: newCoordinate!.longitude) { success, error in
        
            self.whilePostingLocation(false)
            
        if success {
            self.dismiss(animated: true, completion: nil)
            
        } else {
            self.showAlert(title: "Error", message: "Error Adding New Location.", completion: nil)
        }
        
        
        }
        
    }
    
    func setNewCoordinate(){
        
        if let newCoordinate = newCoordinate {
            
            let region = detailMapView.regionThatFits(MKCoordinateRegion(center: newCoordinate, latitudinalMeters: 20000, longitudinalMeters: 20000))
            
            let annotation = MKPointAnnotation()
            
            annotation.title = location
            annotation.coordinate = newCoordinate
            
            detailMapView.addAnnotation(annotation)
            detailMapView.setRegion(region, animated: true)
            
        }
        
        
    }
    
    func whilePostingLocation(_ posting: Bool){
        
        if posting {
            
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.finishAddLocationButton.isEnabled = false
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.finishAddLocationButton.isEnabled = false
            }
            
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !posting
            self.finishAddLocationButton.isEnabled = !posting
        }
        
        
    }
    
    func showAlert(title:String, message: String, completion: (()->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: {
            (completion!())
        })
    }
    

}
