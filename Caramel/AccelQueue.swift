//
//  MovementQueue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreMotion

var _accelQueue = Queue<CMAcceleration>()

class AccelQueue {
    
    class func length() -> Int {
        return _accelQueue.length()
    }
    
    class func addAccel(accel: CMAcceleration) {
        if _accelQueue.length() == Constants.getAccelFrequency() {
            for _ in 0 ..< Constants.getAccelFrequency() {
                _accelQueue.pop()
            }
        }
        _accelQueue.push(accel)
    }
    
    class func isMoving() -> Bool {
        let samples = _accelQueue.asArray()
        let x = getdiff(samples, {(accel: CMAcceleration!) -> Double in accel.x})
        let y = getdiff(samples, {(accel: CMAcceleration!) -> Double in accel.y})
        let z = getdiff(samples, {(accel: CMAcceleration!) -> Double in accel.z})
        if x < 0.1 || x > 0.3 {
            return false
        }
        if y < 0.1 || y > 0.4 {
            return false
        }
        if z < 0.05 || z > 0.35 {
            return false
        }
        return true
    }
    
    private class func getdiff(
        samples: [CMAcceleration],
        getAtt: (CMAcceleration!) -> Double
    ) -> Double {
        var sum = 0.0
        for i in 0 ..< (samples.count - 1) {
            let diff = (getAtt(samples[i+1]) - getAtt(samples[i]))
            sum += diff * diff
        }
        sum /= 50.0
        return sqrt(sum)
    }
}