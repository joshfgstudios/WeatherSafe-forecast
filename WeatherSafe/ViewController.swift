//
//  ViewController.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 8/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    //Outlets
    //------------
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblTempMax: UILabel!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var lblRainChance: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    
    //Properties
    //------------
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var currentLocation: CLLocation?
    var cityName: String?
    var countryName: String?
    
    var weather: Weather!
    var gradientColours = GradientColour(top: warmTop, bottom: warmBottom)
    
    //Functions
    //------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            //Present an alert to ask the user to update their settings
            let alert = UIAlertController(title: "Unable to access location", message: "We don't have permission to access your location, and so we can't provide you with local weather data.  Please enable us to use your location via Settings to get weather information.", preferredStyle: UIAlertControllerStyle.Alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .Default, handler: { (UIAlertAction) -> Void in
                let settingsURL = NSURL(string: "prefs:root=LOCATION_SERVICES")
                if let url = settingsURL {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
            refreshData()
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            refreshData()
        }
    }
    
    func updateUI() {
        lblCurrentTemp.text = weather.currentTemp
        lblTempMax.text = weather.todayMax
        lblTempMin.text = weather.todayMin
        lblRainChance.text = "\(weather.rainProbability) %"
        lblWindSpeed.text = "\(weather.windSpeed) kph"
        lblHumidity.text = "\(weather.humidity) %"
        
        //refreshBackgroundColours()
    }
    
    func refreshData() {
        currentLocation = locationManager.location
        weather = Weather()
        weather.latitude = (currentLocation?.coordinate.latitude)!
        weather.longitude = (currentLocation?.coordinate.longitude)!
        weather.setRequestURL()
        
        geoCoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) -> Void in
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            if let cityName = placeMark?.addressDictionary!["City"] as? String {
                self.cityName = cityName
                if let countryName = placeMark?.addressDictionary!["CountryCode"] as? String {
                    self.countryName = countryName
                    self.lblCityName.text = "\(self.cityName!), \(self.countryName!)"
                }
            }
        }
        
        weather.downloadWeatherDetails { () -> () in
            self.updateUI()
            self.refreshBackgroundColours()
        }
        
    }
    
    func refreshBackgroundColours() {
        
        if let units = NSUserDefaults.standardUserDefaults().valueForKey("units") as? String {
            if units == "c" {
                if Int(weather.currentTemp) >= 32 {
                    gradientColours = GradientColour(top: hotTop, bottom: hotBottom)
                } else if Int(weather.currentTemp) >= 20 {
                    gradientColours = GradientColour(top: warmTop, bottom: warmBottom)
                } else if Int(weather.currentTemp) >= 14 {
                    gradientColours = GradientColour(top: coolTop, bottom: coolBottom)
                } else {
                    gradientColours = GradientColour(top: coldTop, bottom: coldBottom)
                }
            } else if units == "f" {
                if Int(weather.currentTemp) >= 88 {
                    gradientColours = GradientColour(top: hotTop, bottom: hotBottom)
                } else if Int(weather.currentTemp) >= 68 {
                    gradientColours = GradientColour(top: warmTop, bottom: warmBottom)
                } else if Int(weather.currentTemp) >= 57 {
                    gradientColours = GradientColour(top: coolTop, bottom: coolBottom)
                } else {
                    gradientColours = GradientColour(top: coldTop, bottom: coldBottom)
                }
            } else {
                //default to celsius if problem with defaults
                if Int(weather.currentTemp) >= 32 {
                    gradientColours = GradientColour(top: hotTop, bottom: hotBottom)
                } else if Int(weather.currentTemp) >= 20 {
                    gradientColours = GradientColour(top: warmTop, bottom: warmBottom)
                } else if Int(weather.currentTemp) >= 14 {
                    gradientColours = GradientColour(top: coolTop, bottom: coolBottom)
                } else {
                    gradientColours = GradientColour(top: coldTop, bottom: coldBottom)
                }
            }
        } else {
            //default to celsius if user defaults don't exist
            if Int(weather.currentTemp) >= 32 {
                gradientColours = GradientColour(top: hotTop, bottom: hotBottom)
            } else if Int(weather.currentTemp) >= 20 {
                gradientColours = GradientColour(top: warmTop, bottom: warmBottom)
            } else if Int(weather.currentTemp) >= 14 {
                gradientColours = GradientColour(top: coolTop, bottom: coolBottom)
            } else {
                gradientColours = GradientColour(top: coldTop, bottom: coldBottom)
            }
        }
        
        let backgroundLayer = gradientColours.gradientLayer
        backgroundLayer.removeFromSuperlayer()
        view.backgroundColor = UIColor.clearColor()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }


}

