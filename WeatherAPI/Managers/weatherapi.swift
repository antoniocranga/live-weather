//
//  weatherapi.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import Foundation
let api_key : String = "f1b16610f0b440268c4143438212809";
class WeatherManager : ObservableObject
{
    @Published var weather : Welcome?
    static let dummyWeather : Welcome = Welcome(
        location: Location(
            name: "London", region: "City of London, Greater London", country: "United Kingdom", localtime: "2021-09-15 14:36"
        ), current: Current(
            temp_c: 19.0, condition: Condition(
                text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
            ), wind_kph: 6.8, feelslike_c: 19.0
        ), forecast: Forecast(
            forecastday: [
                Forecastday(
                    date: "2021-09-15", day: Day(
                        maxtemp_c: 20.3, mintemp_c: 10.5, condition: Condition(
                            text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                        )
                    ), hour: [ Hour(
                        time_epoch: 1631660400, time: "2021-09-15 00:00", temp_c: 14.8, condition: Condition(
                            text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                        ), wind_kph: 6.8, feelslike_c: 19.0
                    ),
                    Hour(
                       time_epoch: 1631660400, time: "2021-09-15 00:00", temp_c: 14.8, condition: Condition(
                           text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                       ), wind_kph: 6.8, feelslike_c: 19.0
                   )
                    ]),
                Forecastday(
                    date: "2021-09-15", day: Day(
                        maxtemp_c: 20.3, mintemp_c: 10.5, condition: Condition(
                            text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                        )
                    ), hour: [ Hour(
                        time_epoch: 1631660400, time: "2021-09-15 00:00", temp_c: 14.8, condition: Condition(
                            text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                        ), wind_kph: 6.8, feelslike_c: 19.0
                    ),
                    Hour(
                       time_epoch: 1631660400, time: "2021-09-15 00:00", temp_c: 14.8, condition: Condition(
                           text: "Partly cloudy", icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                       ), wind_kph: 6.8, feelslike_c: 19.0
                   )
                    ])
            ])
    )
    let locationManager = LocationManager()
    
    var link : String = ""
    init() {
        if(locationManager.checkStatus() == true)
        {
            
            let lat = locationManager.manager.location!.coordinate.latitude;
            let long = locationManager.manager.location!.coordinate.longitude;
            getWeather(lat: Double(lat), long: Double(long))
        }
        
    }
    func getWeather( lat : Double , long : Double)
    {
        print("Lat : \(lat)"  + " , " + "Long : \(long)")
        link = "https://api.weatherapi.com/v1/forecast.json?key=\(api_key)&q=\(lat),\(long)&days=3&aqi=no&alerts=no";
        guard let url = URL(string : link)
        else
        {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url : url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        {
            
            (data,response,error) in
            if let error = error
            {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Failed")
                return
                
            }
            if response.statusCode == 200
            {
                
                print("Approved")
                guard let data = data else {
                    print("null data")
                    return}
                DispatchQueue.main.async { [self] in
                    do
                    {
                        let decodedWeather = try JSONDecoder().decode(Welcome.self, from: data)
                        self.weather = decodedWeather
                    }
                    catch let error
                    {
                        print("Error decoding: ",error)
                    }
                }
            }
            else{
                print("\(response.description)")
            }
            
            print("Finished")
            
        }
        dataTask.resume()
    }
}
