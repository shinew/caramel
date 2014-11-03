//
//  StressQueue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _stressQueue = Queue<StressScoreInterval>()

class StressQueue {
    
    class func length() -> Int {
        return _stressQueue.length()
    }
    
    class func addNewRawScore(
        rawScore: StressScoreInterval!,
        newScoreCallback: (StressScoreInterval!) -> Void
    ) {
        /*
        What we want to calculate:
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
        newScoreCallback(smoothScore)
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