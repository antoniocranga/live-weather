//
//  WeatherAPIApp.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import SwiftUI

@main
struct WeatherAPIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(WeatherManager())
        }
    }
}
