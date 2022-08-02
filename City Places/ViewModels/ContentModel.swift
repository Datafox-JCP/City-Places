//
//  ContentModel.swift
//  City Places
//
//  Created by Juan Hernandez Pazos on 02/08/22.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override init() {
        // init method of NSObject
        super.init()
        
        // Set content model as the delegate of the location manager
        locationManager.delegate = self
        
        // Request permission from the user
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Location manager delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            // We have permission, start geolocating the user
            locationManager.startUpdatingLocation()
        } else if locationManager.authorizationStatus == .denied {
            // We don´t have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Give us the location of the user
        print(locations.first ?? "no location")
        // Stop requesting the location after we got it once
        locationManager.stopUpdatingLocation()
        // TODO: If we have the coordinates of the user, send into Yelp API
        
    }
}
