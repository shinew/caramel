//
//  TrendGraphView.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-12.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class TrendGraphView: UIView {
    
    private var currentDataValues: [Int]!
    private var currentMaxYValue: Int!
    
    func setCurrentData(dataValues: [Int], maxYValue: Int) {
        self.currentDataValues = dataValues
        self.currentMaxYValue = maxYValue
    }
    
    override func drawRect(rect: CGRect) {
        println("Drawing trend graph")
        
        if self.currentDataValues == nil {
            return
        }
        
        var context = UIGraphicsGetCurrentContext()
        
        //Draws current day/week's data
        
        //Draws area
        CGContextSetFillColorWithColor(context, UIColor(red: 0.30, green: 0.55, blue: 0.76, alpha: 0.8).CGColor) //color dark gray with transparency
        CGContextMoveToPoint(context, 0.0, rect.height) //bottom left
        for index in 0 ..< self.currentDataValues.count {
            CGContextAddLineToPoint(
                context,
                self.getRelativeProportion(index, max: self.currentDataValues.count - 1, height: rect.width),
                rect.height - self.getRelativeProportion(self.currentDataValues[index], max: self.currentMaxYValue, height: rect.height)
            )
        }
        CGContextAddLineToPoint(context, rect.width, rect.height) //bottom right
        CGContextAddLineToPoint(context, 0.0, rect.height) //back to origin
        CGContextFillPath(context) //fill it in
        
        //Draws line separators
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 1.0);
        
        for index in 1 ..< self.currentDataValues.count - 1 {
            let xValue = self.getRelativeProportion(index, max: self.currentDataValues.count - 1, height: rect.width)
            CGContextMoveToPoint(
                context,
                xValue,
                rect.height
            )
            CGContextAddLineToPoint(
                context,
                xValue,
                rect.height - self.getRelativeProportion(self.currentDataValues[index], max: self.currentMaxYValue, height: rect.height)
            )
            CGContextStrokePath(context)
        }
    }
    
    private func getRelativeProportion(value: Int, max: Int, height: CGFloat) -> CGFloat {
        return CGFloat(Double(height) * Double(value) / Double(max))
    }
}
