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
    @IBOutlet weak var lblUnits: UILabel!
    @IBOutlet weak var constrXCloseButton: NSLayoutConstraint!
    @IBOutlet weak var constrXSettingsWindow: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    
    //Properties
    //------------
    
    //Functions
    //------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView.layer.cornerRadius = bgView.frame.width / 92
        bgView.clipsToBounds = true
        
        constrXSettingsWindow.constant -= 60
        constrXCloseButton.constant += 60
        bgView.alpha = 0.0
        btnClose.alpha = 0.0
        
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
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.constrXCloseButton.constant -= 60
            self.constrXSettingsWindow.constant += 60
            self.bgView.alpha = 1.0
            self.btnClose.alpha = 1.0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    //Actions
    //------------
    @IBAction func onClosePressed(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.constrXCloseButton.constant += 60
            self.constrXSettingsWindow.constant -= 60
            self.view.layoutIfNeeded()
            }, completion: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSwitchChanged(sender: AnyObject) {
        if switchUnits.on == true {
            NSUserDefaults.standardUserDefaults().setValue("c", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
            lblUnits.text = "Units:  C"
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "unitsChanged", object: nil))
        } else if switchUnits.on != true {
            NSUserDefaults.standardUserDefaults().setValue("f", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
            lblUnits.text = "Units:  F"
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "unitsChanged", object: nil))
        } else {
            NSUserDefaults.standardUserDefaults().setValue("c", forKey: "units")
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "unitsChanged", object: nil))
            lblUnits.text = "Units:  C"
        }
    }
}
