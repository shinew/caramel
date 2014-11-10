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
let _maxMovementThreshhold = 65.0 //so if 75% movement in last 20s, then moving set to true
let _stressIntervalDuration = 4 * 60 //4 min
let _accelFrequency = 50
let _profileCircleFineness = 5 //in min
let _movementAffectiveDuration = 30
let _stressNotificationIntervalDuration = 5 * 60 //5 min
let _stressNotificationThreshold = 70
let _circleColorYellowThreshold = 70
let _circleColorRedThreshold = 90
let _bluetoothConnectivityDuration = 20.0

class Constants {
    
    class func getMaxNumStressQueue() -> Int { return _maxNumStressQueue }
    
    class func getMaxNumHRQueue() -> Int { return _maxNumHRQueue }
    
    class func getMaxNumMovementQueue() -> Int { return _maxNumMovementQueue }
    
    class func getMaxMovementThreshhold() -> Double { return _maxMovementThreshhold }
    
    class func getStressIntervalDuration() -> Int { return _stressIntervalDuration }
    
    class func getAccelFrequency() -> Int { return _accelFrequency }
    
    class func getProfileCircleFineness() -> Int { return _profileCircleFineness }
    
    class func getMovementAffectiveDuration() -> Int { return _movementAffectiveDuration }
    
    class func getStressNotificationIntervalDuration() -> Int { return _stressNotificationIntervalDuration }
    
    class func getStressNotificationThreshold() -> Int { return _stressNotificationThreshold }
    
    class func getCircleColorYellowThreshold() -> Int { return _circleColorYellowThreshold }
    
    class func getCircleColorRedThreshold() -> Int { return _circleColorRedThreshold }
    
    class func getBluetoothConnectivityDuration() -> Double { return _bluetoothConnectivityDuration }
}