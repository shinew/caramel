//
//  Movement.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-31.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreMotion

var _newMovementCallbacks = Array<(Bool) -> Void>()
var _activityManager: CMMotionActivityManager?
var _motionManager: CMMotionManager?
var _wasMoving = false

class Movement {
    
    class func initalizeManager() {
        if CMMotionActivityManager.isActivityAvailable() {
            Movement.initializeActivityManager()
        } else {
            Movement.initializeMotionManager()
        }
    }
    
    class func addNewMovementCallback(callback: (Bool) -> Void) {
        _newMovementCallbacks.append(callback)
    }

    class func isSteadyMovement() -> Bool {
        return _wasMoving
    }

    private class func initializeActivityManager() -> Void {
        _activityManager = CMMotionActivityManager()
        _activityManager!.startActivityUpdatesToQueue(
            NSOperationQueue.currentQueue(),
            withHandler: {(activity: CMMotionActivity!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if activity.walking || activity.running || activity.cycling {
                        _wasMoving = true
                        println("ActM: Moving")
                        Timer.setLastMovementDate(NSDate())
                    } else if activity.stationary || activity.automotive {
                        _wasMoving = false
                        println("ActM: Still")
                    }
                }
                Movement.invokeCallbacks()
            }
        )
    }
    
    private class func initializeMotionManager() -> Void {
        _motionManager = CMMotionManager()
        _motionManager!.accelerometerUpdateInterval = 1.0/Double(Constants.getAccelFrequency())
        _motionManager!.startAccelerometerUpdatesToQueue(
            NSOperationQueue.currentQueue(),
            withHandler: {(accelerometerData: CMAccelerometerData!, error:NSError!) -> Void in
                AccelQueue.addAccel(accelerometerData.acceleration)
                if AccelQueue.length() == Constants.getAccelFrequency() {
                    let isMoving = AccelQueue.isMoving()
                    MovementQueue.push(isMoving)
                    if isMoving {
                        println("MotM: Moving")
                    } else {
                        println("MotM: Still")
                    }
                    _wasMoving = MovementQueue.isMoving()
                    if _wasMoving {
                        Timer.setLastMovementDate(NSDate())
                    }
                    println("MotM: Needs stress pausing b/c movement: \(_wasMoving)")
                }
                Movement.invokeCallbacks()
            }
        )
    }
    
    private class func invokeCallbacks() {
        for callback in _newMovementCallbacks {
            callback(_wasMoving)
        }
    }
}