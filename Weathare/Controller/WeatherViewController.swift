//
//  ViewController.swift
//  Weathare
//
//  Created by Cassy on 4/14/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    @IBAction func updateLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Enter a city."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let citySearch = searchTextField.text else {
            return
        }
        let citySearchNoSpaces = citySearch.filter { $0 != " " }
        weatherManager.getWeather(cityName: citySearchNoSpaces)
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        self.temperatureLabel.text = weather.temperatureString
        self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        self.cityLabel.text = weather.cityName
    }
    
    func didFailWithError(error: Error) {
        let failAlert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        failAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(failAlert, animated: true, completion: nil)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      let failAlert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        failAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(failAlert, animated: true, completion: nil)
    }
}
