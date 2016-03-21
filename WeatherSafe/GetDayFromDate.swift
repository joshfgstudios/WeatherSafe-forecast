//
//  GetDayFromDate.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 20/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import Foundation

extension NSDate {
    
    func dayOfWeek() -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let fullDate = dateFormatter.stringFromDate(self)
        let splitDate = fullDate.componentsSeparatedByString(",")
        return splitDate[0]
    }
    
}