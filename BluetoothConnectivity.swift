//
//  BluetoothConnectivity.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-09.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class BluetoothConnectivity {
    //Bug fix: Bluetooth drops sometimes (iOS 8 known bug)
    //Fix: restart CBManager if no signal for > 20s
    func setLongRunningTimer() {
        NSTimer.scheduledTimerWithTimeInterval(Constants.getBluetoothConnectivityDuration(), target: self, selector: "checkForBluetooth", userInfo: nil, repeats: true)
    }
    
    @objc func checkForBluetooth() {
        println("(BLConnect) Checking if bluetooth connection dropped")
        if let lastHRReceivedDate = Timer.getLastHRBluetoothReceivedDate() {
            if lastHRReceivedDate.timeIntervalSinceNow < (0.0 - Constants.getBluetoothConnectivityDuration()) {
                println("(BLConnect) Restarting HRBluetooth")
                HRBluetooth.startScanningHRPeripheral()
            }
        }
    }
}