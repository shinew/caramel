//
//  Bluetooth.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreBluetooth

class HRBluetooth: NSObject {
    
    var hrCBManager: HRCentralManager!
    
    override init() {
        self.hrCBManager = HRCentralManager()
        super.init()
    }
    
    //may need to modify this to take on other UUIDs later?
    func startScanningHRPeripheral(hrUpdateCallback: (NSData!) -> Void) {
        self.hrCBManager.startCentralManager(hrUpdateCallback)
    }
}