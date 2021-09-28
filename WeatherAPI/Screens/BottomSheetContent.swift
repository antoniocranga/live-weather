//
//  BottomSheetContent.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 15.09.2021.
//

import SwiftUI

struct BottomSheetContent: View {
    @State var selectedIndex : Int = 0;
    @EnvironmentObject var weatherManager : WeatherManager
    var body: some View {
        VStack(){
            weatherRow(forecast: weatherManager.weather?.forecast.forecastday ?? [],selectedIndex: selectedIndex,callback: self.callback)
            hoursWidget(hours: weatherManager.weather?.forecast.forecastday[selectedIndex].hour ?? [])
            }.background(Color(UIColor.secondarySystemBackground))
    }
    func callback(_ value : Int)->Void
    {
        selectedIndex = value;
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
