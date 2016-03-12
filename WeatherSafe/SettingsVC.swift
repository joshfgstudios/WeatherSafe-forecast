//
//  SettingsVC.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 9/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    //Outlets
    //------------
    @IBOutlet weak var switchUnits: UISwitch!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgTransp: UIView!

    
    //Properties
    //------------
    
    //Functions
    //------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgTransp.alpha = 0.0
        bgView.layer.cornerRadius = bgView.frame.width / 24
        bgView.clipsToBounds = true
        
        if let units = NSUserDefaults.standardUserDefaults().valueForKey("units") as? String {
            if units == "c" {
                switchUnits.on = true
            } else if units == "f" {
                switchUnits.on = false
            } else {
                //default to celsius if can't find user defaults
                switchUnits.on = true
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.bgTransp.alpha = 0.5
            }, completion: nil)
    }
    
    //Actions
    //------------
    @IBAction func onClosePressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSwitchChanged(sender: AnyObject) {
        if switchUnits.on == true {
            NSUserDefaults.standardUserDefaults().setValue("c", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "unitsChanged", object: nil))
        } else if switchUnits.on != true {
            NSUserDefaults.standardUserDefaults().setValue("f", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "unitsChanged", object: nil))
        } else {
            NSUserDefaults.standardUserDefaults().setValue("c", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "unitsChanged", object: nil))
        }
    }
}
