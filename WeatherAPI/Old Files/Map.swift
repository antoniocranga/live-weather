//
//  Map.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import Foundation
import MapKit
import SwiftUI

struct EntireMapView: UIViewRepresentable {
        @EnvironmentObject var weatherManager : WeatherManager
        private let locationManager = LocationManager()
        
        func updateUIView(_ mapView: MKMapView, context: Context) {

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
                
            
            
            mapView.showsUserLocation = true
        }
        func makeUIView(context: Context) -> MKMapView {

            let myMap = MKMapView(frame: .zero)
            let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(EntireMapViewCoordinator.addAnnotation(gesture:)))
            longPress.minimumPressDuration = 0.1
            myMap.addGestureRecognizer(longPress)
            myMap.delegate = context.coordinator
            return myMap

        }

    func makeCoordinator() -> EntireMapViewCoordinator {
        return EntireMapViewCoordinator(self,self.weatherManager)
    }

    class EntireMapViewCoordinator: NSObject, MKMapViewDelegate {
        var entireMapViewController: EntireMapView
        @ObservedObject var weatherManager : WeatherManager
        init(_ control: EntireMapView ,_ weatherManager : WeatherManager) {
          self.entireMapViewController = control
          self.weatherManager = weatherManager
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
    }
}
