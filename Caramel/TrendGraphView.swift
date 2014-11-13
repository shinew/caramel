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
    private var previousDataValues: [Int]!
    private var previousMaxYValue: Int!
    
    func setCurrentData(dataValues: [Int], maxYValue: Int) {
        self.currentDataValues = dataValues
        self.currentMaxYValue = maxYValue
    }
    
    func setPreviousData(dataValues: [Int], maxYValue: Int) {
        self.previousDataValues = dataValues
        self.previousMaxYValue = maxYValue
    }
    
    override func drawRect(rect: CGRect) {
        println("Drawing trend graph")
        
        if self.currentDataValues == nil {
            return
        }
        
        var context = UIGraphicsGetCurrentContext()
        
        //Draws previous data
        self.drawDataArea(self.previousDataValues, max: self.previousMaxYValue, color: UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1.0).CGColor, rect: rect, context: context)
        
        //Draws current data
        self.drawDataArea(self.currentDataValues, max: self.currentMaxYValue, color: UIColor(red: 0.30, green: 0.55, blue: 0.76, alpha: 0.8).CGColor, rect: rect, context: context)
        
        //Draws line separators for current data
        self.drawLineSeparators(self.currentDataValues, max: self.currentMaxYValue, color: UIColor.whiteColor().CGColor, rect: rect, context: context)
    }
    
    private func drawDataArea(data: [Int], max: Int, color: CGColor!, rect: CGRect!, context: CGContext!) {
        CGContextSetFillColorWithColor(context, color) //color dark gray with transparency
        CGContextMoveToPoint(context, 0.0, rect.height) //bottom left
        for index in 0 ..< data.count {
            CGContextAddLineToPoint(
                context,
                self.getRelativeProportion(index, max: data.count - 1, height: rect.width),
                rect.height - self.getRelativeProportion(data[index], max: max, height: rect.height)
            )
        }
        CGContextAddLineToPoint(context, rect.width, rect.height) //bottom right
        CGContextAddLineToPoint(context, 0.0, rect.height) //back to origin
        CGContextFillPath(context) //fill it in
    }
    
    private func drawLineSeparators(data: [Int], max: Int, color: CGColor!, rect: CGRect!, context: CGContext!) {
        CGContextSetStrokeColorWithColor(context, color)
        CGContextSetLineWidth(context, 1.0);
        
        for index in 1 ..< data.count - 1 {
            let xValue = self.getRelativeProportion(index, max: data.count - 1, height: rect.width)
            CGContextMoveToPoint(
                context,
                xValue,
                rect.height
            )
            CGContextAddLineToPoint(
                context,
                xValue,
                rect.height - self.getRelativeProportion(data[index], max: max, height: rect.height)
            )
            CGContextStrokePath(context)
        }
    }
    
    private func getRelativeProportion(value: Int, max: Int, height: CGFloat) -> CGFloat {
        return CGFloat(Double(height) * Double(value) / Double(max))
    }
}