//
//  BottomSheetContent.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 15.09.2021.
//

import SwiftUI

struct BottomSheetContent: View {
    @EnvironmentObject var weatherManager : WeatherManager
    var body: some View {
        VStack(){
            weatherRow(forecast: WeatherManager.dummyWeather.forecast.forecastday)
            
            
        }.background(Color(UIColor.tertiarySystemBackground))
    }
}
/*if(weatherManager.weather != nil)
 {
     VStack(){
         weatherRow(forecast: weatherManager.weather!.forecast.forecastday)
     }.background(Color(UIColor.tertiarySystemBackground))
 }*/
struct BottomSheetContent_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetContent().preferredColorScheme(.light
        ).environmentObject(WeatherManager())
    }
}
