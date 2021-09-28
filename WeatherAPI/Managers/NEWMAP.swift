//
//  NEWMAP.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 15.09.2021.
//

import Foundation
import MapKit
import SwiftUI
class MapViewContainer: ObservableObject {
    
    @Published public private(set) var mapView = MKMapView(frame: .zero)
    
}

struct MKMapViewRepresentable: UIViewRepresentable {
    
    var userTrackingMode: Binding<MKUserTrackingMode>
    @EnvironmentObject var weatherManager : WeatherManager
    private let locationManager = LocationManager()
    
    @EnvironmentObject private var mapViewContainer: MapViewContainer
    
    func makeUIView(context: UIViewRepresentableContext<MKMapViewRepresentable>) -> MKMapView {
        mapViewContainer.mapView.delegate = context.coordinator
        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(MapViewCoordinator.addAnnotation(gesture:)))
        longPress.minimumPressDuration = 0.1
        context.coordinator.followUserIfPossible()
        mapViewContainer.mapView.addGestureRecognizer(longPress)
        return mapViewContainer.mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MKMapViewRepresentable>) {
        
        
        if mapView.userTrackingMode != userTrackingMode.wrappedValue {
            mapView.setUserTrackingMode(userTrackingMode.wrappedValue, animated: true)
            mapView.removeAnnotations(mapView.annotations)
            if(locationManager.checkStatus() == true)
            {
                let coordinate = locationManager.manager.location!.coordinate
                weatherManager.getWeather(lat: Double(coordinate.latitude ), long: Double(coordinate.longitude))
            }
        }
        else {
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        var chicagoCoordinate = CLLocationCoordinate2D()
        chicagoCoordinate.latitude = 41.878113
        chicagoCoordinate.longitude = -87.629799
        var coords = CLLocationCoordinate2D()
        let status = locationManager.checkStatus()
        if( status == true )
        {
            coords = locationManager.manager.location!.coordinate
        }
        
        let region = MKCoordinateRegion(center: status == true ? coords : chicagoCoordinate , span: span)
        
        if(weatherManager.weather  == nil)
        {
            mapView.setRegion(region, animated: true)
        }
        }
        mapView.showsUserLocation = true
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        let coordinator = MapViewCoordinator(self,self.weatherManager)
        return coordinator
    }
    
    // MARK: - Coordinator
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        
        var control: MKMapViewRepresentable
        @ObservedObject var weatherManager : WeatherManager
        let locationManager = CLLocationManager()
        
        init(_ control: MKMapViewRepresentable, _ weatherManager : WeatherManager) {
            self.control = control
            self.weatherManager = weatherManager

            super.init()
            
            setupLocationManager()
        }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.pausesLocationUpdatesAutomatically = true
        }
        
        func followUserIfPossible() {
            switch CLLocationManager().authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                control.userTrackingMode.wrappedValue = .follow
            default:
                break
            }
        }
        
        @objc func addAnnotation(gesture: UIGestureRecognizer) {

            if gesture.state == .ended {
                
                if let mapView = gesture.view as? MKMapView {
                    
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.removeAnnotations(mapView.annotations)
                weatherManager.getWeather(lat: Double(coordinate.latitude ), long: Double(coordinate.longitude))
                mapView.addAnnotation(annotation)
                }
            }
        }
        
        private func present(_ alert: UIAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
            // UIApplication.shared.keyWindow has been deprecated in iOS 13,
            // so you need a little workaround to avoid the compiler warning
            // https://stackoverflow.com/a/58031897/10967642
            
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
        }
        
        // MARK: MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            #if DEBUG
            print("\(type(of: self)).\(#function): userTrackingMode=", terminator: "")
            switch mode {
            case .follow:            print(".follow")
            case .followWithHeading: print(".followWithHeading")
            case .none:              print(".none")
            @unknown default:        print("@unknown")
            }
            #endif
            
            if CLLocationManager.locationServicesEnabled() {
                switch mode {
                case .follow, .followWithHeading:
                    switch CLLocationManager().authorizationStatus {
                    case .notDetermined:
                        locationManager.requestWhenInUseAuthorization()
                    case .restricted:
                        // Possibly due to active restrictions such as parental controls being in place
                        let alert = UIAlertController(title: "Location Permission Restricted", message: "The app cannot access your location. This is possibly due to active restrictions such as parental controls being in place. Please disable or remove them and enable location permissions in settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                            // Redirect to Settings app
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        })
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

                        present(alert)
                        
                        DispatchQueue.main.async {
                            self.control.userTrackingMode.wrappedValue = .none
                        }
                    case .denied:
                        let alert = UIAlertController(title: "Location Permission Denied", message: "Please enable location permissions in settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                            // Redirect to Settings app
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        })
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        present(alert)
                        
                        DispatchQueue.main.async {
                            self.control.userTrackingMode.wrappedValue = .none
                        }
                    default:
                        DispatchQueue.main.async {
                            self.control.userTrackingMode.wrappedValue = mode
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self.control.userTrackingMode.wrappedValue = mode
                    }
                }
            } else {
                let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                    // Redirect to Settings app
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert)
                
                DispatchQueue.main.async {
                    self.control.userTrackingMode.wrappedValue = mode
                }
            }
        }
        
        // MARK: CLLocationManagerDelegate
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            #if DEBUG
            print("\(type(of: self)).\(#function): status=", terminator: "")
            switch status {
            case .notDetermined:       print(".notDetermined")
            case .restricted:          print(".restricted")
            case .denied:              print(".denied")
            case .authorizedAlways:    print(".authorizedAlways")
            case .authorizedWhenInUse: print(".authorizedWhenInUse")
            @unknown default:          print("@unknown")
            }
            #endif
            
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                control.mapViewContainer.mapView.setUserTrackingMode(control.userTrackingMode.wrappedValue, animated: true)
            default:
                control.mapViewContainer.mapView.setUserTrackingMode(.none, animated: true)
            }
        }
        
    }}
