//
//  Movement.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-31.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreMotion

class Movement {
    
    private var activityManager: CMMotionActivityManager?
    private var motionManager: CMMotionManager?
    private var wasMoving = false
    
    init() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.initializeActivityManager()
        } else {
            self.initializeMotionManager()
        }
    }
    
    func isSteadyMovement() -> Bool {
        return self.wasMoving
    }
    
    private func initializeActivityManager() -> Void {
        self.activityManager = CMMotionActivityManager()
        self.activityManager!.startActivityUpdatesToQueue(
            NSOperationQueue.currentQueue(),
            withHandler: {(activity: CMMotionActivity!) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if activity.walking || activity.running || activity.cycling {
                        self.wasMoving = true
                        println("ActM: Moving")
                        Timer.setLastMovementDate(NSDate())
                    } else if activity.stationary || activity.automotive {
                        self.wasMoving = false
                        println("ActM: Still")
                    }
                }
            }
        )
    }
    
    private func initializeMotionManager() -> Void {
        self.motionManager = CMMotionManager()
        self.motionManager!.accelerometerUpdateInterval = 1.0/Double(Constants.getAccelFrequency())
        self.motionManager!.startAccelerometerUpdatesToQueue(
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
                    self.wasMoving = MovementQueue.isMoving()
                    if self.wasMoving {
                        Timer.setLastMovementDate(NSDate())
                    }
                    println("MotM: Needs stress pausing b/c movement: \(self.wasMoving)")
                }
            }
        )
    }
}