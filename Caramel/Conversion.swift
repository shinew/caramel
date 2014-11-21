//
//  Conversion.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class Conversion {
    
    class func stringToDate(dateString: String) -> NSDate! {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(dateString)
        return date
    }
    
    class func dateToString(date: NSDate!) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    class func dateToTimeString(date: NSDate!) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    class func dateToTimelessDate(date: NSDate!) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        return calendar.dateFromComponents(components)!
    }
    
    class func UIColorFromRGB(red: Int!, green: Int!, blue: Int!) -> UIColor {
        return UIColor(
            red: CGFloat(Double(red)/255.0),
            green: CGFloat(Double(green)/255.0),
            blue: CGFloat(Double(blue)/255.0),
            alpha: CGFloat(1.0)
        )
    }
    class func UIColorFromRGB(red: Int!, green: Int!, blue: Int!, alpha: Int!) -> UIColor {
        return UIColor(
            red: CGFloat(Double(red)/255.0),
            green: CGFloat(Double(green)/255.0),
            blue: CGFloat(Double(blue)/255.0),
            alpha: CGFloat(Double(alpha)/100.0)
        )
    }
}