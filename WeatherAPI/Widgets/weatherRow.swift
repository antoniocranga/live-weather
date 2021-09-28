//
//  weatherRow.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import SwiftUI

struct weatherRow: View {
    
    let forecast : [Forecastday]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators : false)
        {
            HStack{
                ForEach(0...(forecast.count - 1),id:\.self)
                {
                    index in
                    let forecastday = forecast[index]
                    weatherWidget(forecastday: forecastday)
                    Divider()
                }
            }.frame(height: 130, alignment: .center)
        }.padding(EdgeInsets.init(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

