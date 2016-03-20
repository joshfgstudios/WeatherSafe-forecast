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
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    @IBOutlet weak var imgMaxTemp: UIImageView!
    @IBOutlet weak var imgMinTemp: UIImageView!
    @IBOutlet weak var imgRainChance: UIImageView!
    @IBOutlet weak var imgWindSpeed: UIImageView!
    @IBOutlet weak var imgHumidity: UIImageView!
    @IBOutlet weak var constrYCurrentTempLabel: NSLayoutConstraint!
    @IBOutlet weak var constrXmaxMinStack: NSLayoutConstraint!
    @IBOutlet weak var constrXdayStats: NSLayoutConstraint!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnForecast: UIButton!
    
    //Properties
    //------------
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var circleView = CircleView()
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshData", name: "unitsChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshBackgroundColours", name: "returningFromForecast", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            refreshData()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toForecast" {
            if let forecastVC = segue.destinationViewController as? ForecastVC {
                forecastVC.weather = weather
                forecastVC.gradientColour = gradientColours
            }
        }
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
            dismissViewControllerAnimated(true, completion: {
                self.refreshData()
            })
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateUI() {
        lblTempMax.text = weather.todayMax
        lblTempMin.text = weather.todayMin
        lblRainChance.text = "\(weather.rainProbability) %"
        lblHumidity.text = "\(weather.humidity) %"
        lblSummary.text = "\(weather.todaySummary)"
        
        if let units = NSUserDefaults.standardUserDefaults().valueForKey("units") as? String {
            if units == "c" {
                lblCurrentTemp.text = "\(weather.currentTemp) °C"
            } else if units == "f" {
                lblCurrentTemp.text = "\(weather.currentTemp) °F"
            } else {
                //default to celsius if problem with defaults
                lblCurrentTemp.text = "\(weather.currentTemp) °C"
            }
        } else {
            //default to celsius if defaults don't exist
            lblCurrentTemp.text = "\(weather.currentTemp) °C"
        }
        
        if let units = NSUserDefaults.standardUserDefaults().valueForKey("units") as? String {
            if units == "c" {
                lblWindSpeed.text = "\(weather.windSpeed) kph"
            } else if units == "f" {
                lblWindSpeed.text = "\(weather.windSpeed) mph"
            } else {
                //default to celsius if problem with defaults
                lblWindSpeed.text = "\(weather.windSpeed) kph"
            }
        } else {
            //default to celsius if defaults don't exist
            lblWindSpeed.text = "\(weather.windSpeed) kph"
        }
    }
    
    func refreshData() {
        startLoading()
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
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "loadingComplete", userInfo: nil, repeats: false)
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
        //backgroundLayer.removeFromSuperlayer()
        //view.backgroundColor = UIColor.clearColor()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    func startLoading() {
        activityIndicator.playLoadingAnimation()
        
        //Layout
        lblCurrentTemp.alpha = 0.0
        lblCityName.alpha = 0.0
        lblTempMax.alpha = 0.0
        lblTempMin.alpha = 0.0
        lblRainChance.alpha = 0.0
        lblWindSpeed.alpha = 0.0
        lblHumidity.alpha = 0.0
        lblSummary.alpha = 0.0
        imgMaxTemp.alpha = 0.0
        imgMinTemp.alpha = 0.0
        imgRainChance.alpha = 0.0
        imgWindSpeed.alpha = 0.0
        imgHumidity.alpha = 0.0
        btnSettings.alpha = 0.0
        btnForecast.alpha = 0.0
        circleView.circleLayer.strokeEnd = 0.0
        constrYCurrentTempLabel.constant += view.bounds.height / 24
        constrXmaxMinStack.constant -= 20
        constrXdayStats.constant -= 20
    }
    
    func loadingComplete() {
        activityIndicator.stopLoadingAnimation()
        addCircleView()
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.lblCurrentTemp.alpha = 1.0
            self.lblCityName.alpha = 1.0
            self.constrYCurrentTempLabel.constant -= self.view.bounds.height / 24
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1.0, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.lblTempMax.alpha = 1.0
            self.lblTempMin.alpha = 1.0
            self.lblSummary.alpha = 1.0
            self.lblRainChance.alpha = 1.0
            self.lblWindSpeed.alpha = 1.0
            self.lblHumidity.alpha = 1.0
            self.imgMaxTemp.alpha = 1.0
            self.imgMinTemp.alpha = 1.0
            self.imgRainChance.alpha = 1.0
            self.imgWindSpeed.alpha = 1.0
            self.imgHumidity.alpha = 1.0
            self.btnForecast.alpha = 1.0
            self.btnSettings.alpha = 1.0
            self.constrXmaxMinStack.constant += 20
            self.constrXdayStats.constant += 20
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func addCircleView() {
        let circleHeight = CGFloat(view.frame.height / 2.5)
        let circleWidth = circleHeight
        
        circleView = CircleView(frame: CGRectMake((view.bounds.width / 2) - (circleWidth / 2), (view.bounds.height / 2.75) - (circleHeight / 2), circleWidth, circleHeight))
        
        view.addSubview(circleView)
        circleView.animateCircle(0.8)
    }

}

