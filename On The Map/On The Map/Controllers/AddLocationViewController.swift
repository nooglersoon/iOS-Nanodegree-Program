//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.setMainStyle()
        activityIndicator.isHidden = true
        
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        
        let geocoder = CLGeocoder()
    
        whileGeocoding(true)
        
        guard let location = locationTextField.text else {
            
            return
            
        }
        
        geocoder.geocodeAddressString(location) { [self] place, error in
            
            if let place = place {
                
                let newLatitude = place.first?.location?.coordinate.latitude
                let newLongitude = place.first?.location?.coordinate.longitude
                
                self.newCoordinate = CLLocationCoordinate2D(latitude: newLatitude!, longitude: newLongitude!)
                
                let viewController = storyboard?.instantiateViewController(identifier: "detailMapVC") as! DetailAddLocationViewController
                viewController.newCoordinate = newCoordinate
                viewController.mediaURL = linkTextField.text!
                viewController.location = locationTextField.text!
                whileGeocoding(false)
                self.navigationController?.pushViewController(viewController, animated: true)
                
                
            } else {
                showAlert(message: "Location Not Found. Check Your Input Location")
                whileGeocoding(false)
                locationTextField.text = ""
            }
            
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func whileGeocoding(_ geocoding: Bool){
        
        if geocoding {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.linkTextField.isEnabled = false
                self.locationTextField.isEnabled = false
                self.findLocationButton.isEnabled = false
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.linkTextField.isEnabled = true
                self.locationTextField.isEnabled = true
                self.findLocationButton.isEnabled = true
            }
            
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !geocoding
            self.linkTextField.isEnabled = !geocoding
            self.locationTextField.isEnabled = !geocoding
            self.findLocationButton.isEnabled = !geocoding
        }
        
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}
