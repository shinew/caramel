//
//  MovementQueue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-01.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _isMovingQueue = Queue<Bool>()

class MovementQueue {
    
    class func push(isMoving: Bool!) {
        _isMovingQueue.push(isMoving)
        if _isMovingQueue.length() > Constants.getMaxNumMovementQueue() {
            _isMovingQueue.pop()
        }
    }
    
    class func isMoving() -> Bool {
        if _isMovingQueue.length() != Constants.getMaxNumMovementQueue() {
            return false
        }
        var sum = 0.0
        var samples = _isMovingQueue.asArray()
        for i in samples {
            if i {
                sum += 1.0
            }
        }
        var result = sum/Double(Constants.getMaxNumMovementQueue()) >= Constants.getMaxMovementThreshhold()
        return result
    }
}