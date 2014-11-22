//
//  StressQueue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _stressQueue = Queue<StressScoreInterval>()
var _newScoreCallbacks = Dictionary<String, (StressScoreInterval!) -> Void>()

class StressQueue {
    
    class func length() -> Int {
        return _stressQueue.length()
    }
    
    class func addNewScoreCallback(key: String, callback: (StressScoreInterval!) -> Void) {
        _newScoreCallbacks[key] = callback
    }
    
    class func addNewRawScore(rawScore: StressScoreInterval!) {
        /*
        What we want to calculate and add:
        DB: smoothened score
        Queue: raw score
        */
        println("Adding a new raw score")
        
        var smoothScore = rawScore
        smoothScore.score = StressQueue.getSmoothScore(rawScore)
        _stressQueue.push(rawScore)
        if _stressQueue.length() == Constants.getMaxNumStressQueue() {
            _stressQueue.pop()
        }
        for (key, callback) in _newScoreCallbacks {
            callback(rawScore)
        }
    }
    
    private class func getSmoothScore(rawScore: StressScoreInterval!) -> Int {
        //we use a moving average to calculated the smoothened score
        println("Calculating smoothened score")
        
        let queueIntervals = _stressQueue.asArray()
        var sum = 0.0
        for interval in queueIntervals {
            sum += Double(interval.score)
        }
        sum += Double(rawScore.score)
        sum /= Double(queueIntervals.count + 1)
        var sumAsInt = Int(sum)
        if sumAsInt <= 10 {
            sumAsInt = 11
        } else if sumAsInt >= 100 {
            sumAsInt = 99
        }
        return sumAsInt
    }
}