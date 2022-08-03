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
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
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
        // Update the authorizationsState property
        self.authorizationState = locationManager.authorizationStatus
        
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
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restaurantKey, location: userLocation!)
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
                    let result = try decoder.decode(BusinessSearch.self, from: data!)
                    
                    // Sort businesses
                    var businesses = result.businesses
                    businesses.sort { (b1, b2) -> Bool in
                        return b1.distance ?? 0 < b2.distance ?? 0
                    }
                    
                        // Call the get image function of the businesses
                    for b in businesses {
                        b.getImageData()
                    }
                    
                    DispatchQueue.main.async {
                        // Assign results to the appropiate property
                        switch category {
                        case Constants.sightsKey:
                            self.sights = businesses
                        case Constants.restaurantKey:
                            self.restaurants = businesses
                        default:
                            break
                        }
                    }
                } catch {
                    print(error)
                }
            }
                // Kick off data task
            dataTask.resume()
        }
    }
}
