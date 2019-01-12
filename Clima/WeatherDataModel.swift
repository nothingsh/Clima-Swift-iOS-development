//
//  WeatherDataModel.swift
//  Clima
//
//  Created by Steven Zhang on 1/3/19.
//  Copyright © 2019 Steven Zhang. All rights reserved.
//

import Foundation
import UIKit

struct WeatherDataModel {
    var cityName: String = ""
    var weather: String = ""
    var temperature: Int = 0
    var weatherIcon: String = ""
    var bgImage: String = ""
    
    mutating func updateInfo(_ json: [String: Any]){
        cityName = (json["name"] as? String ?? "connect error")
        var condition: Int = 500
        
        if let weatherDict = json["weather"] as? [[String:Any]] {
            print("the weatherDict i get is \(weatherDict)")
            weather = weatherDict[0]["description"] as? String ?? "sunny"
            condition = weatherDict[0]["id"] as? Int ?? 500
        }
        
        weatherIcon = updateWeatherIcon(condition: condition)
        bgImage = updateBGImage()
        
        if let temperatureDict = json["main"] as? [String: Any] {
            print("the main dict i get is \(temperatureDict)")
            if let temp = temperatureDict["temp"] as? Double {
                print("the temporary temperature is \(temp)")
                temperature = Int( temp - 273.15 )
            }
        }
        print("the total info of weather is: \(cityName), \(weather), \(temperature), \(weatherIcon)")
    }
    
    init() {
        cityName = "海淀区"
        weather = "sunny"
        temperature = 1
        weatherIcon = "sun"
        bgImage = updateBGImage()
    }
    
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
            
        case 0...300 :
            return "storm"
            
        case 301...500 :
            return "rain-2"
            
        case 501...600 :
            return "rain"
            
        case 601...700 :
            return "snow"
            
        case 701...771 :
            return "cloudy"
            
        case 772...799 :
            return "wind"
            
        case 800 :
            return "sun"
            
        case 801...804 :
            return "cloud"
            
        case 900...903, 905...1000  :
            return "windy"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sun"
            
        default :
            return "circle"
        }
        
    }
    
    func updateBGImage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        print("the hour now is \(hour)")
        
        switch hour {
        case 6...9:
            return "bg-morning"
        case 10...14:
            return "bg-noon"
        case 15...16:
            return "bg-afternoon"
        default:
            return "bg-night"
        }
    }
}
