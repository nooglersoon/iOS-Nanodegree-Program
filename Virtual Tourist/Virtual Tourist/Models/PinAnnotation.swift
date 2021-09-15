//
//  PinAnnotation.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 04/09/21.
//

import Foundation
import MapKit

class PinAnnotation: MKPointAnnotation {
    
    var pin: Pin
    
    init(pin: Pin) {
        self.pin = pin
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        self.title = pin.address
    }
    
    
}
