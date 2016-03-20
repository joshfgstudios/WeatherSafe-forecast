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
        //view.backgroundColor = UIColor.clearColor()
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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func onBackPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "returningFromForecast", object: nil))
    }
    
}
