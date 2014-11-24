//
//  ScoreSmootheningQueue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class ScoreSmootheningQueue {
    //Note: this should only be used by the StressScoreManager

    var rawScoreQueue = Queue<StressScoreInterval>()
    
    func length() -> Int {
        return self.rawScoreQueue.length()
    }
    
    func addRawScore(rawScore: StressScoreInterval!) -> StressScoreInterval! {
        //returns smoothened score
        
        println("Adding a new raw score to smoothening queue")
        
        var smoothScore = rawScore
        smoothScore.score = self.getSmoothScore(rawScore)
        self.rawScoreQueue.push(rawScore)
        if self.rawScoreQueue.length() == Constants.getMaxNumStressQueue() {
            self.rawScoreQueue.pop()
        }
        
        return smoothScore
    }
    
    private func getSmoothScore(rawScore: StressScoreInterval!) -> Int {
        //we use a moving average to calculated the smoothened score
        
        println("Calculating smoothened score")
        
        let queueIntervals = self.rawScoreQueue.asArray()
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