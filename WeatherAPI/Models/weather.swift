// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}
	// MARK: - Current
struct Current: Codable {
    let temp_c: Double
    let condition: Condition
    let wind_kph: Double
    let feelslike_c: Double

    enum CodingKeys: String, CodingKey {
        
        case temp_c
        case condition
        case wind_kph
        case feelslike_c
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date : String
    let day: Day
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case date,day, hour
    }
    
    func getCurrentHour() -> Hour
    {
        for x in self.hour
        {
            if(x.time_epoch >= Int(NSDate().timeIntervalSince1970))
            {
                return x;
            }
        }
        return self.hour[0];
    }
}

// MARK: - Day
struct Day: Codable {
    let maxtemp_c: Double
    let mintemp_c : Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtemp_c
        case mintemp_c
        case condition
    }
}

// MARK: - Hour
struct Hour: Codable {
    let time_epoch: Int
    let time: String
    let temp_c: Double
    let condition: Condition
    let wind_kph: Double
    let feelslike_c: Double

    enum CodingKeys: String, CodingKey {
        case time_epoch
        case time
        case temp_c
        case condition
        case wind_kph
        case feelslike_c
    }
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country
        case localtime
    }
}
