//
//  CircleView.swift
//  WeatherSafe
//
//  Created by Joshua Ide on 13/03/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import UIKit

class CircleView: UIView {

    let circleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width) / 2, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat((M_PI * 2.0) - M_PI_2), clockwise: true)
        
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circleLayer.strokeEnd = 1.0
        circleLayer.addAnimation(animation, forKey: "animateCircle")
        
    }
    
}
