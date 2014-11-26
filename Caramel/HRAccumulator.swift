//
//  HRAccumulator.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-25.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

let _BEATS_FOR_STRESS = 256
var _lastSentDate: NSDate?
var _nextEstimatedStressStartDate: NSDate?
var _nextEstimatedStressEndDate: NSDate?
var _hrDates = [NSDate]()
var _activated = false

class HRAccumulator {
    
    class func activated() -> Bool {
        return _activated
    }
    
    class func startCountdown() {
        _activated = true
    }
    
    class func stopCountdown() {
        _activated = false
    }
    
    class func restartCountdown() {
        _hrDates.removeAll(keepCapacity: true)
    }
    
    class func addHRDate(date: NSDate!) {
        _hrDates.append(date!)
    }
    
    class func sentHRRequestDate(date: NSDate!) {
        _lastSentDate = date
        _nextEstimatedStressEndDate = date.dateByAddingTimeInterval(Double(Constants.getMaxNumHRQueue()))
        _nextEstimatedStressStartDate =
            _nextEstimatedStressEndDate!.dateByAddingTimeInterval(
                0.0 - Double(Constants.getStressIntervalDuration())
            )
        
        for i in 0 ..< _hrDates.count {
            if _hrDates[i].compare(_nextEstimatedStressStartDate!) != NSComparisonResult.OrderedAscending {
                // >=
                _hrDates[0 ..< i] = []
                break
            }
        }
    }
    
    class func beatsLeftUntilUpdate() -> Int {
        return max(0, _BEATS_FOR_STRESS - _hrDates.count)
    }
}