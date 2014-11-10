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

    //may need to modify this to take on other UUIDs later?
    class func startScanningHRPeripheral() {
        if _hrUpdateCallback != nil {
            _hrCBManager.startCentralManager(_hrUpdateCallback!)
        }
    }
}