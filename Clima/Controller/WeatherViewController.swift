//
//  ViewController.swift
//  Clima
//
//  Created by Ketan Choyal on 22/11/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Links to UI
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let API_KEY = "2064f0948e1c0c9d4b678a346b78c43c"
    
    //TODO: Instant Variable declaration
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Setup location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    //MARK: Networking
    func getWeatherData(_ url : String, _ param : [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: param).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                print("Successfully got Weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                
                print("Failed to get data")
                self.locationLabel.text = "Connection issue!"
                
            }
            
        }
    
    }
    
    //MARK: JSON Parsing
    
    func updateWeatherData(json:JSON) {
        
        if let temp = json["main"]["temp"].double {
        
            weatherDataModel.temperature = Int(temp - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }
        else {
            
            locationLabel.text = "Weather Unavailabel"
            
        }
        
    }
    
    //MARK: UI Updates
    
    func updateUIWithWeatherData() {
        
        locationLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherImage.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    //MARK: Location Manager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("lon = \(location.coordinate.longitude), lat = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String:String] = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
            
            getWeatherData(WEATHER_URL, params)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        
        locationLabel.text = "Location Unavailable"
        
    }
    
    //MARK: Change City Delegate Methods
    
    func userEnteredLocation(city: String) {
        
        let param : [String : String] = ["q" : city, "appid" : API_KEY]
        
        getWeatherData(WEATHER_URL, param)
        
    }
    
    //Prepare method for sending data from one storyboard to another
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
            
        }
        
    }


}

