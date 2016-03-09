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
    
    //Properties
    //------------
    
    //Functions
    //------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let units = NSUserDefaults.standardUserDefaults().valueForKey("units") as? String {
            if units == "c" {
                switchUnits.on = true
            } else if units == "f" {
                switchUnits.on = false
            } else {
                switchUnits.on = true
            }
        }
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
        } else if switchUnits.on != true {
            NSUserDefaults.standardUserDefaults().setValue("f", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            NSUserDefaults.standardUserDefaults().setValue("c", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
