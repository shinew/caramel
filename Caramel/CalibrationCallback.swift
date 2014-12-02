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
        var hrSample = HRDecoder.dataToHRSample(data)
        if hrSample != nil && hrSample!.hr != nil && hrSample!.hr < 150 {
            Timer.setLastHRBluetoothReceivedDate(NSDate())
            HRAccumulator.addHRDate(NSDate())
            HRQueue.push(hrSample!)
            println("(Calibration) HRQueue length: \(HRQueue.length())")
            
            var dashboardCallback = DashboardCallback.getDashboardCalibrationCallback()
            
            if dashboardCallback != nil {
                dashboardCallback!(hrSample: hrSample!)
            }
        }
    }
}