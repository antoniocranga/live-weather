//
//  weatherRow.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import SwiftUI

struct weatherRow: View {
    
    let forecast : [Forecastday]
    let selectedIndex : Int
    var callback : (Int) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators : false)
        {
            HStack{
                if(forecast.count > 0)
                {ForEach(0...(forecast.count - 1),id:\.self)
                {
                    index in
                    let forecastday = forecast[index]
                    weatherWidget(forecastday: forecastday,selected: index == selectedIndex)
                        .onTapGesture(count:1)
                        {
                            self.callback(index);
                        }
                    Divider()
                }
                
                }
            }.frame(height: 150, alignment: .center)
            
        }.padding(EdgeInsets.init(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

