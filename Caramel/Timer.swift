//
//  Timer.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _lastHRBluetoothReceivedDate: NSDate?
var _lastHRSentDate: NSDate?
var _lastMovementDate: NSDate?
var _lastStressNotifDate: NSDate?
var _lastMemoryWarningNotificationDate: NSDate?

class Timer {
    //This class keeps various dates
    
    class func getLastHRBluetoothReceivedDate() -> NSDate? { return _lastHRBluetoothReceivedDate }
    class func setLastHRBluetoothReceivedDate(date: NSDate!) { _lastHRBluetoothReceivedDate = date }
    
    class func getLastHRSentDate() -> NSDate? { return _lastHRSentDate }
    class func setLastHRSentDate(date: NSDate!) { _lastHRSentDate = date }
    
    class func getLastMovementDate() -> NSDate? { return _lastMovementDate }
    class func setLastMovementDate(date: NSDate!) { _lastMovementDate = date }
    
    class func getLastStressNotifDate() -> NSDate? { return _lastStressNotifDate }
    class func setLastStressNotifDate(date: NSDate!) { _lastStressNotifDate = date }
    
    class func getLastMemoryWarningNotificationDate() -> NSDate? {
        return _lastMemoryWarningNotificationDate
    }
    class func setLastMemoryWarningNotificationDate(date: NSDate!) {
        _lastMemoryWarningNotificationDate = date
    }
}