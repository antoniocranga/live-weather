//
//  hoursWidget.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 15.09.2021.
//

import SwiftUI

struct hoursWidget: View {
    let hours : [Hour]
    var body: some View {
        ScrollView(.horizontal)
        {
            HStack(){
                ForEach(0...(hours.count - 1), id : \.self)
                {
                    index in
                    
                    let hour : Hour = hours[index]
                    VStack()
                    {
                        
                        Text(hour.time.getHourFromString())
                        RemoteImage(url: URL(string: "https:\(hour.condition.icon)")).aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40, alignment: .center)
                        
                        Text("\(hour.temp_c.removeTrailingZero()) °").font(.headline)
                    }.padding()
                }
                
                
            }.padding(.leading)
        }
    }
}

struct hoursWidget_Previews: PreviewProvider {
    static var previews: some View {
        hoursWidget(hours: WeatherManager.dummyWeather.forecast.forecastday[0].hour)
    }
}
