//
//  WeatherViewController.swift
//  Clima
//
//  Created by Steven Zhang on 1/3/19.
//  Copyright © 2019 Steven Zhang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UpdateCityInMain {
    
    var WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    var lat:Double = 0.0
    var lon:Double = 0.0
    
    let locationManager = CLLocationManager()
    var weatherModel = WeatherDataModel()
    
    // outlets
    @IBOutlet weak var cityNameOutlet: UILabel!
    @IBOutlet weak var weatherIconOutlet: UIImageView!
    @IBOutlet weak var weatherInfoOutlet: UILabel!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    
    
    
    // Switch view
    @IBAction func switchToCopyrightView(_ sender: UIButton) {
        performSegue(withIdentifier: "copyrightView", sender: self)
    }
    
//    @IBAction func switchToChangeCityView(_ sender: UIButton) {
//        performSegue(withIdentifier: "changeCityView", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityView" {
            let desinationVC = segue.destination as! ChangeCityViewController
            desinationVC.delegate = self
        }
    }
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // TODO: get user location here
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        lat = locationManager.location?.coordinate.latitude ?? 116.31
        lon = locationManager.location?.coordinate.longitude ?? 39.95
        
        print("my location coordinates is:")
        print(locationManager.location?.coordinate ?? "null")
        
        let urlString = WEATHER_URL + "?lat=\(lat)&lon=\(lon)&APPID=\(APP_ID)"
        parseJSON(urlString)               // get weather via locaiton coordinates
    }
    
    
    
    
    // Show popup to the user if lcation has been denied access
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied){
            showLocationDiabledPopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameOutlet.text = "Location Unavailable"
    }
    
    func showLocationDiabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "Inorder to show local weather, we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Setting", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    // get json from api and parse it
    func parseJSON(_ urlString: String){
        let url = URL(string: urlString)
        
        if url != nil {
            let alert = UIAlertController(title: "Error", message: "input error!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        } else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else{
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else{
                print("Not containing Json")
                return
            }
            
            if let code = json["cod"] as? Int{
                if code == 404{
                    let alert = UIAlertController(title: "Error", message: "we can't get weather of the city you input!", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            print(json)
            self.weatherModel.updateInfo(json)
            self.updateUIWeatherData()
            
            if let array = json["weather"] as? [String]{
                // WeatherDataModel.updateInfo(array)
                print("weather string is:\(array)")
            }
        }
        task.resume()
    }

    

    
    // update UI
    func updateUIWeatherData() {
        // add to main thread for the idiot swift
        DispatchQueue.global(qos: .utility).async {
            DispatchQueue.main.async {
                self.cityNameOutlet.text = self.weatherModel.cityName
                self.weatherIconOutlet.image = UIImage(named: self.weatherModel.weatherIcon)
                self.backgroundImageOutlet.image = UIImage(named: self.weatherModel.bgImage)
                self.weatherInfoOutlet.text = "\(self.weatherModel.weather):\(self.weatherModel.temperature)℃"
            }
        }
    }

    
    
    // Write changeCity method here:
    func changeCity(_ city: String){
        weatherModel.cityName = city
        let urlString = WEATHER_URL + "?q=\(city)&APPID=\(APP_ID)"
        print(urlString)
        parseJSON(urlString)        // get weather via city.
    }
}


