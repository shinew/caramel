//
//  BluetoothConnectivity.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-09.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class BluetoothConnectivity {
    
    var connectedCallback: ((Void) -> Void)?
    var disconnectedCallback: ((Void) -> Void)?
    var timer: NSTimer!
    
    init() { }
    
    func setCallbacks(connectedCallback: ((Void) -> Void)?, disconnectedCallback: ((Void) -> Void)?) {
        self.connectedCallback = connectedCallback
        self.disconnectedCallback = disconnectedCallback
    }

    func setLongRunningTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("checkForBluetooth"), userInfo: nil, repeats: true)
    }
    
    func disableTimer() {
        self.timer.invalidate()
    }
    
    @objc func checkForBluetooth() {
        println("(BLConnect) Checking if bluetooth connection dropped")
        if let lastHRReceivedDate = Timer.getLastHRBluetoothReceivedDate() {
            if lastHRReceivedDate.timeIntervalSinceNow >= (0.0 - Constants.getBluetoothConnectivityDuration()) {
                
                if self.connectedCallback != nil { self.connectedCallback!() }
                return
            }
        }
        if self.disconnectedCallback != nil { self.disconnectedCallback!() }
    }
}
