//
//  CircleView.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ProfileCircleView: UIView {
    
    let calmColor: UIColor! = Conversion.UIColorFromRGB(74, green: 139, blue: 194)
    let littleStressedColor: UIColor! = Conversion.UIColorFromRGB(255, green: 221, blue: 69)
    //let veryStressedColor: UIColor! = Conversion.UIColorFromRGB(232, green: 79, blue: 56)
    let veryStressedColor: UIColor! = Conversion.UIColorFromRGB(0, green: 0, blue: 0)
    let numSlices = 60*24/Constants.getProfileCircleFineness()
    
    override func drawRect(rect: CGRect) {
        println("Drawing profile circle")
        var context = UIGraphicsGetCurrentContext()
        let thickness = CGFloat(34.0)
        CGContextSetLineWidth(context, thickness)
        for index in 0 ..< self.numSlices {
            //Calculate the angle in radians that the slice to be drawn will start and end
            //Calculate 1/96th of a circle, multiply by the index, add 3/2 pi to make 0 at the top,
            // mod 2pi to keep the range between 0 and 2pi
            //Start Angle = ([(1/96) * (2pi) * (index)] + [1.5pi]) % (2pi)
            //End Angle = ([(1/96) * (2pi) * (index + 1)] + [1.5pi]) % (2pi)
            //We do this for all 96 slices each time setNeedsDisplay() is called
            let a1 = M_PI * 2.0 / Double(self.numSlices) * Double(index)
            let a2 = M_PI * 2.0 / Double(self.numSlices) * Double(index+1)
            let b = M_PI * 3.0 / 2.0
            let c = M_PI * 2.0
            
            var sliceStart = CGFloat((a1+b)%c)
            var sliceEnd = CGFloat((a2+b)%c)
            //The color of the slice has equal red, green, and blue values to make it grayscale
            //If the stress value is 0.0 (no value has been added to that index) then we set the
            // alpha value to 0 (transparent)
            if index % 3 == 0 {
                self.calmColor.set()
            } else if index % 3 == 1 {
                self.littleStressedColor.set()
            } else {
                self.veryStressedColor.set()
            }
            //Finally, we add the slice to context and draw it
            CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, (self.frame.size.width - thickness) / 2, sliceStart, sliceEnd, 0)
            CGContextStrokePath(context)
        }
    }
}