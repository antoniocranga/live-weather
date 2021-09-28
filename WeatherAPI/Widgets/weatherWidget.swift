//
//  weatherWidget.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import SwiftUI

struct weatherWidget: View {
    let forecastday : Forecastday
    let currentHour : Hour
    init(forecastday : Forecastday) {
        self.forecastday = forecastday
        currentHour = forecastday.getCurrentHour();
    }
    func getToday() -> String
    {
        let timestamp = forecastday.date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy-MM-dd"
        let date = dateformatter.date(from: timestamp)!
        let now = dateformatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        let formatedDate = dateformatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        
        return now == formatedDate ?  "Today" :  formatedDate;
        
    }
    var body: some View {
        VStack(alignment:  .center , spacing:20){
            Text(getToday())
            Text(currentHour.temp_c.removeTrailingZero() + " °C")
            RemoteImage(url: URL(string: "https:\(currentHour.condition.icon)")).aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40, alignment: .center)
        }
        .frame(width: 80, height: 130, alignment: .center)
        .padding()
        
    }
}
