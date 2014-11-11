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
var _lastLowStressNotifDate: NSDate?
var _lastHighStressNotifDate: NSDate?

class Timer {
    //This class keeps various dates
    
    class func getLastHRBluetoothReceivedDate() -> NSDate? { return _lastHRBluetoothReceivedDate }
    class func setLastHRBluetoothReceivedDate(date: NSDate!) { _lastHRBluetoothReceivedDate = date }
    
    class func getLastHRSentDate() -> NSDate? { return _lastHRSentDate }
    class func setLastHRSentDate(date: NSDate!) { _lastHRSentDate = date }
    
    class func getLastMovementDate() -> NSDate? { return _lastMovementDate }
    class func setLastMovementDate(date: NSDate!) { _lastMovementDate = date }
    
    class func getLastLowStressNotifDate() -> NSDate? { return _lastLowStressNotifDate }
    class func setLastLowStressNotifDate(date: NSDate!) { _lastLowStressNotifDate = date }
    
    class func getLastHighStressNotifDate() -> NSDate? { return _lastHighStressNotifDate }
    class func setLastHighStressNotifDate(date: NSDate!) { _lastHighStressNotifDate = date }
}