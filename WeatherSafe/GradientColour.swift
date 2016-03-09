//
//  GradientColour.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 9/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import Foundation
import UIKit

class GradientColour {
    
    let gradientLayer: CAGradientLayer!
    
    init(top: CGColor, bottom: CGColor) {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [top, bottom]
        gradientLayer.locations = [0.0, 1.0]
    }
    
}