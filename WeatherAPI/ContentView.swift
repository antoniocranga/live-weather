//
//  ContentView.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import SwiftUI
import CoreLocation
struct ContentView: View {
    @State private var bottomSheetShown = false
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var manager : WeatherManager
    var body: some View {
        ZStack()
        {
            VStack()
            {
                MapView().environmentObject(manager)
                if(locationManager.checkStatus() != true)
                {Button("Allow location")
                {
                    locationManager.manager.requestWhenInUseAuthorization()
                    if(locationManager.checkStatus() == true)
                    {
                        let coords = locationManager.manager.location!
                        manager.getWeather(lat: Double(coords.coordinate.latitude), long: Double(coords.coordinate.longitude))
                    }
                }
                }
            }
            VStack()
            {
                Spacer()
                GeometryReader { geometry in
                    BottomSheetView(
                        
                        isOpen: self.$bottomSheetShown,
                        maxHeight: geometry.size.height * 0.8
                    ) {
                        BottomSheetContent().environmentObject(manager)
                    }.ignoresSafeArea()
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(WeatherManager())
    }
}
