//
//  CalibrationCallback.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class CalibrationCallback {
    
    func newHeartRateCallback(data: NSData!) -> Void {
        println("(Calibration) Received new heart rate data")
        Timer.setLastHRBluetoothReceivedDate(NSDate())
        var hrSample = HRDecoder.dataToHRSample(data)
        if hrSample != nil {
            HRQueue.push(hrSample!)
            println("(Calibration) HRQueue length: \(HRQueue.length())")
        }
    }
    
    func httpResponseCallbackGenerator(type: String) -> (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void {
        
        func closure (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
            println("(\(type)) finished sending \(type) request!")
            if response == nil {
                println("(\(type)) Request did not go through")
                Notification.sendNoInternetNotification()
                return
            }
            println("(\(type)) response status code: \(response.statusCode)")
        }
        
        return closure
    }
}