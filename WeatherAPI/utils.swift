//
//  utils.swift
//  WeatherAPI
//
//  Created by Crangă Antonio on 13.09.2021.
//

import Foundation

extension Double
{
    func removeTrailingZero() -> String
    {
        let formatter = NumberFormatter()
        let number = NSNumber(value : self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16;
        return String(formatter.string(from: number) ?? "");
    }
}

extension String
{
    func getHourFromString() -> String
    {
        let formatter = DateFormatter()
        print(self)
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.date(from: self)!
        formatter.dateFormat = "hh a"
        return formatter.string(from: date)
    }
}
