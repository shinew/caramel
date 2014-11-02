//
//  Timer.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _lastHRSentDate: NSDate?
var _lastWalkingDate: NSDate?
var _lastMovementDate: NSDate?

class Timer {
    //This class keeps various dates
    
    class func getLastHRSentDate() -> NSDate? {
        return _lastHRSentDate
    }
    
    class func setLastHRSentDate(date: NSDate!) {
        _lastHRSentDate = date
    }
    
    class func getLastWalkingDate() -> NSDate? {
        return _lastWalkingDate
    }
    
    class func setLastWalkingDate(date: NSDate!) {
        _lastWalkingDate = date
    }
    
    class func getLastMovementDate() -> NSDate? {
        return _lastMovementDate
    }
    
    class func setLastMovementDate(date: NSDate!) {
        _lastMovementDate = date
    }
}