//
//  Bluetooth.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreBluetooth

var _hrCBManager = HRCentralManager()
var _hrUpdateCallback: ((NSData!) -> Void)?

class HRBluetooth: NSObject {
    
    class func setHRUpdateCallback(hrUpdateCallback: (NSData!) -> Void) {
        _hrUpdateCallback = hrUpdateCallback
    }
    
    class func getHRUpdateCallback() -> ((NSData!) -> Void)? {
        return _hrUpdateCallback
    }
    
    class func setHRUpdateCallback(callback: ((NSData!) -> Void)?) {
        _hrUpdateCallback = callback
    }

    class func startScanningHRPeripheral() {
        _hrCBManager.startCentralManager()
    }
}