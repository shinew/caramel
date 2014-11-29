//
//  HRSensorIrregularity.swift
//  GetBeyond
//
//  Created by Shine Wang on 2014-11-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _irregularCounter = 0

class HRSensorIrregularity {
    
    class func addIrregularCount() {
        _irregularCounter++
    }
    
    class func isIrregular() -> Bool {
        if _irregularCounter < 30 {
            return false
        }
        return true
    }
}