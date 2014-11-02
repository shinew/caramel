//
//  DashboardCallback.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class DashboardCallback {
    
    var todayOverallLabel: UILabel!
    var lastStressScoreInterval: StressScoreInterval!
    var updatedScoreCallback: (interval: StressScoreInterval!) -> Void
    
    init(updatedScoreCallback: (interval: StressScoreInterval!) -> Void) {
        self.updatedScoreCallback = updatedScoreCallback
    }
    
    func newHeartRateCallback(data: NSData!) -> Void {
        println("Received new heart rate data")
        var hrSample = HRDecoder.dataToHRSample(data)
        if hrSample != nil {
            HRQueue.push(hrSample!)
            println("HRQueue length: \(HRQueue.length())")
            if HRQueue.length() == Constants.getMaxNumHRQueue() {
                var currentHRs = HRQueue.popAll()
                Timer.setLastHRSentDate(currentHRs.last!.date)
                HTTPRequest.sendHRRequest(currentHRs, self.hrHTTPResponseCallback)
            }
        }
    }
    
    func hrHTTPResponseCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("finished sending HR request!")
        println("(HR) response status code: \(response.statusCode)")
        if response != nil && response.statusCode == 201 {
            //send stress request
            var stressInterval = StressScoreInterval(
                score: 0,
                startDate: Timer.getLastHRSentDate()!.dateByAddingTimeInterval(0.0 - Double(Constants.getStressIntervalDuration())),
                endDate: Timer.getLastHRSentDate()!
            )
            self.lastStressScoreInterval = stressInterval
            HTTPRequest.sendStressRequest(stressInterval, self.hrStressResponseCallback)
        }
    }
    
    func hrStressResponseCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("finished sending Stress request!")
        println("(Stress) response status code: \(response.statusCode)")
        if response != nil && response.statusCode == 200 {
            let json = data as [String: AnyObject]
            let score = json["Score"] as Int
            println("(Stress) Received stress score: \(score)")
            self.lastStressScoreInterval.score = score
            StressQueue.addNewRawScore(self.lastStressScoreInterval, newScoreCallback: self.updatedScoreCallback)
        }
    }
}