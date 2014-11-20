//
//  DashboardCallback.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class DashboardCallback {
    
    var lastStressScoreInterval: StressScoreInterval!
    var currentHRLabel: UILabel!
    
    init(updatedScoreCallback: (interval: StressScoreInterval!) -> Void, currentHRLabel: UILabel!) {
        StressQueue.addNewScoreCallback(updatedScoreCallback)
        self.currentHRLabel = currentHRLabel
    }
    
    func newHeartRateCallback(data: NSData!) -> Void {
        println("Received new heart rate data")
        var hrSample = HRDecoder.dataToHRSample(data)
        if hrSample != nil && hrSample!.hr != nil && hrSample!.hr < 150 {
            Timer.setLastHRBluetoothReceivedDate(NSDate())
            dispatch_async(dispatch_get_main_queue(), {
                self.currentHRLabel.text = "\(hrSample!.hr!)"
            })
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
        println("(HR) finished sending HR request!")
        if response == nil {
            println("(HR) Request did not go through")
            Notification.sendNoInternetNotification()
            return
        }
        println("(HR) response status code: \(response.statusCode)")
        if response.statusCode == 201 {
            //send stress request
            var stressInterval = StressScoreInterval(
                score: 0,
                startDate: Timer.getLastHRSentDate()!.dateByAddingTimeInterval(0.0 - Double(Constants.getStressIntervalDuration())),
                endDate: Timer.getLastHRSentDate()!,
                userID: User.getUserID()
            )
            self.lastStressScoreInterval = stressInterval
            HTTPRequest.sendStressRequest(stressInterval, self.hrStressResponseCallback)
        }
    }
    
    func hrStressResponseCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        if response == nil {
            println("(Stress) Request did not go through")
            Notification.sendNoInternetNotification()
            return
        }
        println("(Stress) finished sending Stress request!")
        println("(Stress) response status code: \(response.statusCode)")
        if response != nil && response.statusCode == 200 {
            let json = data as [String: AnyObject]
            if json["Score"] is Int {
                let score = json["Score"] as Int
                println("(Stress) Received stress score: \(score)")
                self.lastStressScoreInterval.score = score
                StressQueue.addNewRawScore(self.lastStressScoreInterval)
            }
        }
    }
}