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
        
        lblDay1.text = "\(weather?.UNIXDay1)"
        lblDay2.text = "\(weather?.UNIXDay2)"
        lblDay3.text = "\(weather?.UNIXDay3)"
        lblDay4.text = "\(weather?.UNIXDay4)"
        lblDay5.text = "\(weather?.UNIXDay5)"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func onBackPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "returningFromForecast", object: nil))
    }
    
}
