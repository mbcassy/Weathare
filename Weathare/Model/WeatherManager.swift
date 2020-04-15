//
//  WeatherManager.swift
//  Weathare
//
//  Created by Cassy on 4/15/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4bb8e85f53eda4fe06e4f3a97a99f374&units=imperial"
    var delegate: WeatherManagerDelegate?
    
    func getWeather(cityName: String) {
        let URLString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: URLString)
    }
    
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let URLString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: URLString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let networkError = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error: networkError)
                }
                return
            }
            
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    DispatchQueue.main.async {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            DispatchQueue.main.async {
                self.delegate?.didFailWithError(error: error)
            }
            return nil
        }
    }
}
