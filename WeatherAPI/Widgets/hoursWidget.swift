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
        ScrollView(.vertical)
        {
            VStack(){
                if(hours.count > 0){
                ForEach(0...(hours.count - 1), id : \.self)
                {
                    index in
                    
                    let hour : Hour = hours[index]
                    HStack()
                    {
                        
                        Text(hour.time.getHourFromString())
                        Spacer()
                        RemoteImage(url: URL(string: "https:\(hour.condition.icon)")).aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: .center)
                        Text("\(hour.temp_c.removeTrailingZero())°C").font(.headline)
                        
                    }.padding(.top).padding(.bottom)
                    Divider()
                }
                   
                }
                
            }.padding()
        }
    }
}

struct hoursWidget_Previews: PreviewProvider {
    static var previews: some View {
        hoursWidget(hours: WeatherManager.dummyWeather.forecast.forecastday[0].hour)
    }
}
