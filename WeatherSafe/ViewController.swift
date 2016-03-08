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
    
    
    //Properties
    //------------
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var currentLocation: CLLocation?
    var cityName: String?
    var countryName: String?
    
    var weather: Weather!
    
    
    //Functions
    //------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
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
        }
    }
    
    func updateUI() {
        lblCurrentTemp.text = weather.currentTemp
        lblTempMax.text = weather.todayMax
        lblTempMin.text = weather.todayMin
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
        }
        
    }


}

