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
    private var _todayMax: String!
    private var _todayMin: String!
    private var _rainProbability: String!
    private var _windSpeed: String!
    private var _humidity: String!
    
    var currentTemp: String {

        if _currentTemp == nil {
            _currentTemp = "-"
        }
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
    
    var todayMax: String {
        
        if _todayMax == nil {
            _todayMax = "-"
        }
        
        return _todayMax
    }
    
    var todayMin: String {
        
        if _todayMin == nil {
            _todayMin = "-"
        }
        
        return _todayMin
    }
    
    var rainProbability: String {
        
        if _rainProbability == nil {
            _rainProbability = "-"
        }
        
        return _rainProbability
    }
    
    var windSpeed: String {
        
        if _windSpeed == nil {
            _windSpeed = "-"
        }
        
        return _windSpeed
    }
    
    var humidity: String {
        
        if _humidity == nil {
            _humidity = "-"
        }
        
        return _humidity
    }
    
    func setRequestURL() {
        _weatherURL = "\(URL_BASE)\(API_KEY)\(_latitude),\(_longitude)\(UNITS_CELSIUS)"
    }
    
    func downloadWeatherDetails(complete: DownloadComplete) {
        
        let url = NSURL(string: _weatherURL)!
        
        //Alamofire request
        //----------------
        Alamofire.request(.GET, url).responseJSON { response in
         
            let result = response.result
            
            //Top level dictionary
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                //Current values
                if let currentDict = dict["currently"] as? Dictionary<String, AnyObject> {
                    if let currentTemp = currentDict["temperature"] as? Int {
                        self._currentTemp = "\(currentTemp)"
                    }
                }
                
                //Daily values
                if let dailyDict = dict["daily"] as? Dictionary<String, AnyObject> {
                    if let data = dailyDict["data"] as? [Dictionary<String, AnyObject>] where data.count > 0 {
                        if let todayMax = data[0]["temperatureMax"] as? Int {
                            self._todayMax = "\(todayMax)"
                        }
                        
                        if let todayMin = data[0]["temperatureMin"] as? Int {
                            self._todayMin = "\(todayMin)"
                        }
                        
                        if let rainProbability = data[0]["precipProbability"] as? Double {
                            self._rainProbability = "\(round(100 * rainProbability))"
                        }
                        
                        if let windSpeed = data[0]["windSpeed"] as? Double {
                            self._windSpeed = "\(windSpeed)"
                        }
                        
                        if let humidity = data[0]["humidity"] as? Double {
                            self._humidity = "\(round(100 * humidity))"
                        }
                    }
                }
            }
            complete()
        }
        //----------------
        //End alamofire request
        
    }
    
}