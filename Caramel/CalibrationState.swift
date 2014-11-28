//
//  CalibrationState.swift
//  GetBeyond
//
//  Created by Shine Wang on 2014-11-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _isCalibrating = false

class CalibrationState {
    
    class func setCalibrationState(isCalibrating: Bool) {
        _isCalibrating = isCalibrating
    }
    
    class func getCalibrationState() -> Bool {
        return _isCalibrating
    }
}