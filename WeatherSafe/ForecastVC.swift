//
//  ForecastVC.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 20/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import UIKit

class ForecastVC: UIViewController {

    //Outlets
    @IBOutlet weak var lblDay1: UILabel!
    @IBOutlet weak var lblDay1Max: UILabel!
    @IBOutlet weak var lblDay1Min: UILabel!
    @IBOutlet weak var lblDay2: UILabel!
    @IBOutlet weak var lblDay2Max: UILabel!
    @IBOutlet weak var lblDay2Min: UILabel!
    @IBOutlet weak var lblDay3: UILabel!
    @IBOutlet weak var lblDay3Max: UILabel!
    @IBOutlet weak var lblDay3Min: UILabel!
    @IBOutlet weak var lblDay4: UILabel!
    @IBOutlet weak var lblDay4Max: UILabel!
    @IBOutlet weak var lblDay4Min: UILabel!
    @IBOutlet weak var lblDay5: UILabel!
    @IBOutlet weak var lblDay5Max: UILabel!
    @IBOutlet weak var lblDay5Min: UILabel!
    @IBOutlet weak var imgDay1: UIImageView!
    @IBOutlet weak var imgDay2: UIImageView!
    @IBOutlet weak var imgDay3: UIImageView!
    @IBOutlet weak var imgDay4: UIImageView!
    @IBOutlet weak var imgDay5: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var constrLeadingStack: NSLayoutConstraint!
    @IBOutlet weak var constrLeadingBack: NSLayoutConstraint!

    
    //Properties
    var weather: Weather?
    var gradientColour: GradientColour?
    
    var day1 = NSDate()
    var day2 = NSDate()
    var day3 = NSDate()
    var day4 = NSDate()
    var day5 = NSDate()
    
    
    //Functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        //Update UI
        let backgroundLayer = gradientColour!.gradientLayer
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
        
        day1 = NSDate(timeIntervalSince1970: (weather?.UNIXDay1)!)
        day2 = NSDate(timeIntervalSince1970: (weather?.UNIXDay2)!)
        day3 = NSDate(timeIntervalSince1970: (weather?.UNIXDay3)!)
        day4 = NSDate(timeIntervalSince1970: (weather?.UNIXDay4)!)
        day5 = NSDate(timeIntervalSince1970: (weather?.UNIXDay5)!)
        
        lblDay1.text = "\(day1.dayOfWeek()!)"
        lblDay2.text = "\(day2.dayOfWeek()!)"
        lblDay3.text = "\(day3.dayOfWeek()!)"
        lblDay4.text = "\(day4.dayOfWeek()!)"
        lblDay5.text = "\(day5.dayOfWeek()!)"
        
        lblDay1Max.text = weather?.day1Max
        lblDay2Max.text = weather?.day2Max
        lblDay3Max.text = weather?.day3Max
        lblDay4Max.text = weather?.day4Max
        lblDay5Max.text = weather?.day5Max
        
        lblDay1Min.text = weather?.day1Min
        lblDay2Min.text = weather?.day2Min
        lblDay3Min.text = weather?.day3Min
        lblDay4Min.text = weather?.day4Min
        lblDay5Min.text = weather?.day5Min
        
        updateIcons()
        
        
        constrLeadingStack.constant += 120
        constrLeadingBack.constant += 120
        lblDay1.alpha = 0.0
        lblDay2.alpha = 0.0
        lblDay3.alpha = 0.0
        lblDay4.alpha = 0.0
        lblDay5.alpha = 0.0
        lblDay1Min.alpha = 0.0
        lblDay2Min.alpha = 0.0
        lblDay3Min.alpha = 0.0
        lblDay4Min.alpha = 0.0
        lblDay5Min.alpha = 0.0
        lblDay1Max.alpha = 0.0
        lblDay2Max.alpha = 0.0
        lblDay3Max.alpha = 0.0
        lblDay4Max.alpha = 0.0
        lblDay5Max.alpha = 0.0
        imgDay1.alpha = 0.0
        imgDay2.alpha = 0.0
        imgDay3.alpha = 0.0
        imgDay4.alpha = 0.0
        imgDay5.alpha = 0.0
        btnBack.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.constrLeadingStack.constant -= 120
            self.constrLeadingBack.constant -= 120
            self.lblDay1.alpha = 1.0
            self.lblDay2.alpha = 1.0
            self.lblDay3.alpha = 1.0
            self.lblDay4.alpha = 1.0
            self.lblDay5.alpha = 1.0
            self.lblDay1Min.alpha = 1.0
            self.lblDay2Min.alpha = 1.0
            self.lblDay3Min.alpha = 1.0
            self.lblDay4Min.alpha = 1.0
            self.lblDay5Min.alpha = 1.0
            self.lblDay1Max.alpha = 1.0
            self.lblDay2Max.alpha = 1.0
            self.lblDay3Max.alpha = 1.0
            self.lblDay4Max.alpha = 1.0
            self.lblDay5Max.alpha = 1.0
            self.imgDay1.alpha = 1.0
            self.imgDay2.alpha = 1.0
            self.imgDay3.alpha = 1.0
            self.imgDay4.alpha = 1.0
            self.imgDay5.alpha = 1.0
            self.btnBack.alpha = 1.0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func updateIcons() {
        switch weather?.day1Icon {
            case "clear-day"?, "clear-night"?: imgDay1.image = UIImage(named: "sun")
            case "partly-cloudy-day"?, "partly-cloudy-night"?: imgDay1.image = UIImage(named: "partly-cloudy")
            case "rain"?: imgDay1.image = UIImage(named: "rain")
            case "snow"?, "sleet"?: imgDay1.image = UIImage(named: "snow")
            case "wind"?, "fog"?: imgDay1.image = UIImage(named: "fog")
            case "cloudy"?: imgDay1.image = UIImage(named: "cloudy")
        default: imgDay1.image = UIImage(named: "partly-cloudy")
        }
        
        switch weather?.day2Icon {
            case "clear-day"?, "clear-night"?: imgDay2.image = UIImage(named: "sun")
            case "partly-cloudy-day"?, "partly-cloudy-night"?: imgDay2.image = UIImage(named: "partly-cloudy")
            case "rain"?: imgDay2.image = UIImage(named: "rain")
            case "snow"?, "sleet"?: imgDay2.image = UIImage(named: "snow")
            case "wind"?, "fog"?: imgDay2.image = UIImage(named: "fog")
            case "cloudy"?: imgDay2.image = UIImage(named: "cloudy")
        default: imgDay2.image = UIImage(named: "partly-cloudy")
        }
        
        switch weather?.day3Icon {
            case "clear-day"?, "clear-night"?: imgDay3.image = UIImage(named: "sun")
            case "partly-cloudy-day"?, "partly-cloudy-night"?: imgDay3.image = UIImage(named: "partly-cloudy")
            case "rain"?: imgDay3.image = UIImage(named: "rain")
            case "snow"?, "sleet"?: imgDay3.image = UIImage(named: "snow")
            case "wind"?, "fog"?: imgDay3.image = UIImage(named: "fog")
            case "cloudy"?: imgDay3.image = UIImage(named: "cloudy")
        default: imgDay3.image = UIImage(named: "partly-cloudy")
        }
        
        switch weather?.day4Icon {
            case "clear-day"?, "clear-night"?: imgDay4.image = UIImage(named: "sun")
            case "partly-cloudy-day"?, "partly-cloudy-night"?: imgDay4.image = UIImage(named: "partly-cloudy")
            case "rain"?: imgDay4.image = UIImage(named: "rain")
            case "snow"?, "sleet"?: imgDay4.image = UIImage(named: "snow")
            case "wind"?, "fog"?: imgDay4.image = UIImage(named: "fog")
            case "cloudy"?: imgDay4.image = UIImage(named: "cloudy")
        default: imgDay4.image = UIImage(named: "partly-cloudy")
        }
        
        switch weather?.day5Icon {
            case "clear-day"?, "clear-night"?: imgDay5.image = UIImage(named: "sun")
            case "partly-cloudy-day"?, "partly-cloudy-night"?: imgDay5.image = UIImage(named: "partly-cloudy")
            case "rain"?: imgDay5.image = UIImage(named: "rain")
            case "snow"?, "sleet"?: imgDay5.image = UIImage(named: "snow")
            case "wind"?, "fog"?: imgDay5.image = UIImage(named: "fog")
            case "cloudy"?: imgDay5.image = UIImage(named: "cloudy")
        default: imgDay5.image = UIImage(named: "partly-cloudy")
        }
    }

    //Actions
    @IBAction func onBackPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "returningFromForecast", object: nil))
    }
    
}
