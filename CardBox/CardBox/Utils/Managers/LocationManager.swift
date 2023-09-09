//
//  LocationWorker.swift
//  CardBox
//
//  Created by Minjong Ha on 2022/03/26.
//

import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    //func setLocation() {
    func getLocation() -> String {
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US_POSIX")
        
        if (latitude != nil && longitude != nil) {
            let findLocation = CLLocation(latitude: latitude!, longitude: longitude!)
            var locationAddr: String?
            
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                if let address: [CLPlacemark] = placemarks {
                    let addr = (address.last?.name)! + ", " + (address.last?.locality)!// + ", " + (address.last?.administrativeArea)!
                    locationAddr = addr
                }
            })
            while locationAddr == nil {} // Wait for geocoder converts location
            return locationAddr!
            
        }
        else {
            return "Unable to get Location"
        }
    }
    
     
    //func locationConfig() {
    func requestLocation() -> String {
        let authorizationStatus = CLLocationManager().authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            self.requestPermission()
            fallthrough // jump to 'default'
        default:
            return self.getLocation()
        }
    }
    
}
