//
//  Weather.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 8/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class Weather {
    
    private var _currentTemp: String!
    private var _weatherURL: String!
    private var _latitude: CLLocationDegrees!
    private var _longitude: CLLocationDegrees!
    
    var currentTemp: String {
        return _currentTemp
    }
    
    var latitude: CLLocationDegrees {
        get {
            return _latitude
        }
        
        set {
            _latitude = newValue
        }
    }
    
    var longitude: CLLocationDegrees {
        get {
            return _longitude
        }
        
        set {
            _longitude = newValue
        }
    }
    
    func setRequestURL() {
        _weatherURL = "\(URL_BASE)\(API_KEY)\(_latitude),\(_longitude)\(UNITS_CELSIUS)"
    }
    
    func downloadWeatherDetails(complete: DownloadComplete) {
        
    }
    
}