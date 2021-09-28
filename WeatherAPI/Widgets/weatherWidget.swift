//
//  weatherWidget.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import SwiftUI

struct weatherWidget: View {
    let selected : Bool
    let forecastday : Forecastday
    let currentHour : Hour
    init(forecastday : Forecastday,selected : Bool) {
        self.forecastday = forecastday
        self.selected = selected
        self.currentHour = forecastday.getCurrentHour();
    }
    func getToday() -> String
    {
        let timestamp = forecastday.date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy-MM-dd"
        let date = dateformatter.date(from: timestamp)!
        let now = dateformatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        let formatedDate = dateformatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        let prefix = String(formatedDate.prefix(3))
        return now == formatedDate ?  "Today" :  prefix
        
    }
    var body: some View {
        VStack(alignment:  .center , spacing:20){
            Text(getToday())
                .padding(.leading).padding(.trailing)
                
            Text(currentHour.temp_c.removeTrailingZero() + " °C")
                .padding(.leading).padding(.trailing)
            RemoteImage(url: URL(string: "https:\(currentHour.condition.icon)")).aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.leading).padding(.trailing)
            if(selected == true)
            {
                Color.blue
                    .frame(width:110,height:3)
            }
        }
        .frame(width: 110, height: 150, alignment: .center)
        
        
    }
}
