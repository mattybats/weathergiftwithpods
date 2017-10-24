//
//  WeatherLocation.swift
//  WeatherGiftUpdated
//
//  Created by Matthew Batsinelas on 10/24/17.
//  Copyright © 2017 Matthew Batsinelas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("*****\(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("Could not return temperature")

                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
