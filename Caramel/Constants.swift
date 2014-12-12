//
//  Constants.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

let _maxNumHRQueue = 30
let _maxNumStressQueue = 3
let _maxNumMovementQueue = 20
let _maxMovementThreshhold = 75.0 //so if 75% movement in last 20s, then moving set to true
let _stressIntervalDuration = 5 * 60 //5 min
let _accelFrequency = 50
let _profileTrendFineness = 5 //in min
let _movementAffectiveDuration = 30
let _defaultStressNotificationInterval = 10 * 60 //10 min
let _stressDiscardInterval = 5 * 60 //5 min
let _stressNotificationThreshold = 70
let _circleColorYellowThreshold = 70
let _circleColorRedThreshold = 90
let _bluetoothConnectivityDuration = 4.0
let _bluetoothReconnectInterval = 10.0
let _memoryWarningThrottleDuration = 10.0 * 60.0
let _blueCalmColor = Conversion.UIColorFromRGB(103, green: 107, blue: 251)
let _orangeTenseColor = UIColor.orangeColor()
let _redStressedColor = UIColor.redColor()

class Constants {
    
    class func getMaxNumStressQueue() -> Int { return _maxNumStressQueue }
    
    class func getMaxNumHRQueue() -> Int { return _maxNumHRQueue }
    
    class func getMaxNumMovementQueue() -> Int { return _maxNumMovementQueue }
    
    class func getMaxMovementThreshhold() -> Double { return _maxMovementThreshhold }
    
    class func getStressIntervalDuration() -> Int { return _stressIntervalDuration }
    
    class func getAccelFrequency() -> Int { return _accelFrequency }
    
    class func getProfileTrendFineness() -> Int { return _profileTrendFineness }
    
    class func getMovementAffectiveDuration() -> Int { return _movementAffectiveDuration }
    
    class func getDefaultStressNotificationInterval() -> Int { return _defaultStressNotificationInterval }
    
    class func getStressDiscardInterval() -> Int { return _stressDiscardInterval }
    
    class func getStressNotificationThreshold() -> Int { return _stressNotificationThreshold }
    
    class func getCircleColorYellowThreshold() -> Int { return _circleColorYellowThreshold }
    
    class func getCircleColorRedThreshold() -> Int { return _circleColorRedThreshold }
    
    class func getBluetoothConnectivityDuration() -> Double { return _bluetoothConnectivityDuration }
    
    class func getBluetoothReconnectInterval() -> Double { return _bluetoothReconnectInterval }
    
    class func getMemoryWarningThrottleDuration() -> Double { return _memoryWarningThrottleDuration }
    
    class func getCalmColor() -> UIColor { return _blueCalmColor }
    
    class func getTenseColor() -> UIColor { return _orangeTenseColor }
    
    class func getStressedColor() -> UIColor { return _redStressedColor }
}