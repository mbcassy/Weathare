//
//  WeatherModel.swift
//  Weathare
//
//  Created by Cassy on 4/15/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
         switch conditionId {
               case 200...202:
                   return "cloud.bolt.rain"
               case 210...232:
                   return "cloud.bolt"
               case 300...321:
                   return "cloud.drizzle"
               case 500...501:
                   return "cloud.rain"
               case 502...531:
                   return "cloud.heavyrain"
               case 600...602:
                   return "cloud.snow"
               case 611...622:
                   return "cloud.sleet"
               case 701...781:
                   return "cloud.fog"
               case 800:
                   return "sun.max"
               case 801...803:
                   return "cloud.sun"
               case 804:
                   return "cloud"
               default:
                   return "cloud"
               }
    }
}
