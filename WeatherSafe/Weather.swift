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
    private var _todaySummary: String!
    
    private var _UNIXDay1: Double!
    private var _day1Max: String!
    private var _day1Min: String!
    
    private var _UNIXDay2: Double!
    private var _day2Max: String!
    private var _day2Min: String!
    
    private var _UNIXDay3: Double!
    private var _day3Max: String!
    private var _day3Min: String!
    
    private var _UNIXDay4: Double!
    private var _day4Max: String!
    private var _day4Min: String!
    
    private var _UNIXDay5: Double!
    private var _day5Max: String!
    private var _day5Min: String!
    
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
    
    var todaySummary: String {
        if _todaySummary == nil {
            _todaySummary = "-"
        }
        
        return _todaySummary
    }
    
    var UNIXDay1: Double {
        if _UNIXDay1 == nil {
            _UNIXDay1 = 0
        }
        
        return _UNIXDay1
    }
    
    var day1Max: String {
        if _day1Max == nil {
            _day1Max = "-"
        }
        
        return _day1Max
    }
    
    var day1Min: String {
        if _day1Min == nil {
            _day1Min = "-"
        }
        
        return _day1Min
    }
    
    var UNIXDay2: Double {
        if _UNIXDay2 == nil {
            _UNIXDay2 = 0
        }
        
        return _UNIXDay2
    }
    
    var day2Max: String {
        if _day2Max == nil {
            _day2Max = "-"
        }
        
        return _day2Max
    }
    
    var day2Min: String {
        if _day2Min == nil {
            _day2Min = "-"
        }
        
        return _day2Min
    }
    
    var UNIXDay3: Double {
        if _UNIXDay3 == nil {
            _UNIXDay3 = 0
        }
        
        return _UNIXDay3
    }
    
    var day3Max: String {
        if _day3Max == nil {
            _day3Max = "-"
        }
        
        return _day3Max
    }
    
    var day3Min: String {
        if _day3Min == nil {
            _day3Min = "-"
        }
        
        return _day3Min
    }
    
    var UNIXDay4: Double {
        if _UNIXDay4 == nil {
            _UNIXDay4 = 0
        }
        
        return _UNIXDay4
    }
    
    var day4Max: String {
        if _day4Max == nil {
            _day4Max = "-"
        }
        
        return _day4Max
    }
    
    var day4Min: String {
        if _day4Min == nil {
            _day4Min = "-"
        }
        
        return _day4Min
    }
    
    var UNIXDay5: Double {
        if _UNIXDay5 == nil {
            _UNIXDay5 = 0
        }
        
        return _UNIXDay5
    }
    
    var day5Max: String {
        if _day5Max == nil {
            _day5Max = "-"
        }
        
        return _day5Max
    }
    
    var day5Min: String {
        if _day5Min == nil {
            _day5Min = "-"
        }
        
        return _day5Min
    }
    
    func setRequestURL() {
        if let units = NSUserDefaults.standardUserDefaults().valueForKey("units") as? String {
            if units == "c" {
                _weatherURL = "\(URL_BASE)\(API_KEY)\(_latitude),\(_longitude)\(UNITS_CELSIUS)"
            } else if units == "f" {
                _weatherURL = "\(URL_BASE)\(API_KEY)\(_latitude),\(_longitude)"
            } else {
                _weatherURL = "\(URL_BASE)\(API_KEY)\(_latitude),\(_longitude)\(UNITS_CELSIUS)"
            }
        } else {
            //default to celsius if can't find user defaults
            _weatherURL = "\(URL_BASE)\(API_KEY)\(_latitude),\(_longitude)\(UNITS_CELSIUS)"
        }
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
                    
                    if let humidity = currentDict["humidity"] as? Double {
                        self._humidity = "\(round(100 * humidity))"
                    }
                }
                
                //Hourly - for the summary of the day
                if let hourlyDict = dict["hourly"] as? Dictionary<String, AnyObject> {
                    if let summary = hourlyDict["summary"] as? String {
                        self._todaySummary = summary
                    }
                }
                
                //Daily values
                if let dailyDict = dict["daily"] as? Dictionary<String, AnyObject> {
                    if let data = dailyDict["data"] as? [Dictionary<String, AnyObject>] where data.count > 0 {
                        //Today
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
                        
                        //Forecast
                        if let day1Date = data[1]["time"] as? Double {
                            self._UNIXDay1 = day1Date
                        }
                        
                        if let day1Max = data[1]["temperatureMax"] as? Int {
                            self._day1Max = "\(day1Max)"
                        }
                        
                        if let day1Min = data[1]["temperatureMin"] as? Int {
                            self._day1Min = "\(day1Min)"
                        }
                        
                        if let day2Date = data[2]["time"] as? Double {
                            self._UNIXDay2 = day2Date
                        }
                        
                        if let day2Max = data[2]["temperatureMax"] as? Int {
                            self._day2Max = "\(day2Max)"
                        }
                        
                        if let day2Min = data[2]["temperatureMin"] as? Int {
                            self._day2Min = "\(day2Min)"
                        }
                        
                        if let day3Date = data[3]["time"] as? Double {
                            self._UNIXDay3 = day3Date
                        }
                        
                        if let day3Max = data[3]["temperatureMax"] as? Int {
                            self._day3Max = "\(day3Max)"
                        }
                        
                        if let day3Min = data[3]["temperatureMin"] as? Int {
                            self._day3Min = "\(day3Min)"
                        }
                        
                        if let day4Date = data[4]["time"] as? Double {
                            self._UNIXDay4 = day4Date
                        }
                        
                        if let day4Max = data[4]["temperatureMax"] as? Int {
                            self._day4Max = "\(day4Max)"
                        }
                        
                        if let day4Min = data[4]["temperatureMin"] as? Int {
                            self._day4Min = "\(day4Min)"
                        }
                        
                        if let day5Date = data[5]["time"] as? Double {
                            self._UNIXDay5 = day5Date
                        }
                        
                        if let day5Max = data[5]["temperatureMax"] as? Int {
                            self._day5Max = "\(day5Max)"
                        }
                        
                        if let day5Min = data[5]["temperatureMin"] as? Int {
                            self._day5Min = "\(day5Min)"
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