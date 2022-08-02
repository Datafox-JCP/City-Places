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
        let userLocation = locations.first
        
        if userLocation != nil {
                // We have a location
                // Stop requesting the location after we got it once
            locationManager.stopUpdatingLocation()
                // If we have the coordinates of the user, send into Yelp API
            getBusinesses(category: "arts", location: userLocation!)
                // getBusinesses(category: "restaurants", location: userLocation!)
        }
    }
    
        // MARK: - Yelp API methods
    func getBusinesses(category: String, location: CLLocation) {
        /*
         / String path
         let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
         */
        var urlComponents = URLComponents(string: Constants.apiUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: Constants.sightsKey),
            URLQueryItem(name: "limit", value: "10")
        ]
            // Create a url object
        let url = urlComponents?.url
        
        if let url = url {
                // Create a URLRequest object
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
                
                // Get the session and kick off the task
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                    // Check if there's an error
                guard error == nil else {
                        // There was an error
                    return
                }
                    // Handle the response
                do {
                        // Create json decoder
                    let decoder = JSONDecoder()
                        // Decode
                    //let modules = try decoder.decode([Module].self, from: data!)
                    
                    DispatchQueue.main.async {
                            // Append parsed modules into modules property
                        //self.modules += modules
                    }
                } catch {
                    // Couldn't parse the json
                }
            }
                // Kick off data task
            dataTask.resume()
        }
    }
}
