//
//  MainMapViewController.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController {
    
    var students = StudentModel.students
    let coordinate = CLLocationCoordinate2D(latitude: 36.778259, longitude: -119.417931)
    
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMapView.delegate = self
        
        let region = mainMapView.regionThatFits(MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000000, longitudinalMeters: 2000000))
        
        activityIndicator.startAnimating()
        OTMClient.getStudents(completion: getStudentHandlerForAnnotation(response:error:))
        
        mainMapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mainMapView.setRegion(region, animated: true)
        
        
        
    }
    
    
    @IBAction func addLocationTapped(_ sender: Any) {
        
        let addLocationVC = storyboard?.instantiateViewController(identifier: "addLocationVC") as! AddLocationViewController
        present(addLocationVC, animated: true, completion: nil)
        
    }
    
    @IBAction func refreshDataTapped(_ sender: Any) {
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        whileLogingOut(true)
        
        OTMClient.userLogout(completion: userLoggingOutHandler(complete:error:))
    }
    
    private func getStudentHandlerForAnnotation(response: [StudentResponseModel], error: Error?) {
        
        activityIndicator.stopAnimating()
        
        if error == nil {
            
            students = response
            
            for student in students {
                
                let annotation = MKPointAnnotation()
                annotation.title = student.firstName + " " + student.lastName
                annotation.subtitle = student.mediaURL
                annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
                mainMapView.addAnnotation(annotation)
                
            }
            
            
            
            
        } else {
            
            showAlert(message: "Error Getting Student's Location Data")
            
        }
        
    }
    
    func userLoggingOutHandler(complete: Bool, error: Error?){
        
        whileLogingOut(false)
        
        if complete {
            dismiss(animated: true, completion: nil)
        } else {
            
            DispatchQueue.main.async {
                self.showAlert(message: "Log Out Failed")
            }
            
        }
        
    }
    
    func whileLogingOut(_ loggingOut: Bool){
        
        if loggingOut {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.refreshButton.isEnabled = false
                self.logOutButton.isEnabled = false
                self.addLocationButton.isEnabled = false
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.refreshButton.isEnabled = true
                self.logOutButton.isEnabled = true
                self.addLocationButton.isEnabled = true
            }
            
        }
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = !loggingOut
            self.refreshButton.isEnabled = !loggingOut
            self.logOutButton.isEnabled = !loggingOut
            self.addLocationButton.isEnabled = !loggingOut
        }
        
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


class CustomAnnotationView: MKPinAnnotationView {
    
    let infoButton = UIButton(type: .infoLight)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // infoButton.addTarget(self, action: #selector(goToURL), for: .touchUpInside)
        
        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .infoDark)
        
        rightCalloutAccessoryView?.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(infoSelected)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func infoSelected(){
        
        if let url = URL(string: (annotation?.subtitle)!!) {
            print(url)
            UIApplication.shared.open(url)
        } else {
            print("URL Invalid")
        }
        
        
    }
    
    
}

extension MainMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let url = URL(string: (view.annotation?.subtitle)!!) {
            print(url)
            UIApplication.shared.open(url)
        } else {
            print("URL Invalid")
        }
    }
    
    
}
