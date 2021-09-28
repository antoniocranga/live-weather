//
//  LocationManager.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    func checkStatus() -> Bool?
    {
        if (CLLocationManager.locationServicesEnabled()) {
            switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    return true;
                @unknown default:
                    return nil;
            }
        }
        return nil;
        
    }
}

