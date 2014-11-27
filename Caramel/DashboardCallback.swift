//
//  DashboardCallback.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

var _dashboardSoftCallback: ((hrSample: HRSample!) -> Void)?

class DashboardCallback {
    
    var lastStressScoreInterval: StressScoreInterval! //used to keep track of start-end
    var currentHRLabel: UILabel!
    var countdownHRLabel: UILabel!
    var countdownDescriptionLabel: UILabel!
    var updatedScoreCallback: ((interval: StressScoreInterval!) -> Void)!

    init(updatedScoreCallback: (
        interval: StressScoreInterval!) -> Void,
        currentHRLabel: UILabel!,
        countdownHRLabel: UILabel!,
        countdownDescriptionLabel: UILabel!
    ) {
        self.updatedScoreCallback = updatedScoreCallback
        self.currentHRLabel = currentHRLabel
        self.countdownHRLabel = countdownHRLabel
        self.countdownDescriptionLabel = countdownDescriptionLabel
        _dashboardSoftCallback = self.dashboardSoftCallback
    }
    
    class func getDashboardCalibrationCallback() -> ((hrSample: HRSample!) -> Void)? {
        return _dashboardSoftCallback
    }
    
    func dashboardSoftCallback(hrSample: HRSample!) {
        self.currentHRLabel.font = UIFont(name: "Univers Light Condensed", size: 50)
        dispatch_async(dispatch_get_main_queue(), {
            self.currentHRLabel.text = "\(hrSample!.hr!)"
        })
    }
    
    func newHeartRateCallback(data: NSData!) -> Void {
        println("Received new heart rate data")
        var hrSample = HRDecoder.dataToHRSample(data)
        if hrSample != nil && hrSample!.hr != nil && hrSample!.hr < 150 {
            
            Timer.setLastHRBluetoothReceivedDate(NSDate())
            
            HRAccumulator.addHRDate(NSDate())
            var newCountdownValue = HRAccumulator.beatsLeftUntilUpdate()
            if HRAccumulator.activated() {
                dispatch_async(dispatch_get_main_queue(), {
                    self.countdownHRLabel.hidden = false
                    self.countdownHRLabel.text = "\(newCountdownValue)"
                    self.countdownDescriptionLabel.hidden = false
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.countdownHRLabel.hidden = true
                    self.countdownDescriptionLabel.hidden = true
                })
            }
            
            self.dashboardSoftCallback(hrSample)
            
            HRQueue.push(hrSample!)
            println("HRQueue length: \(HRQueue.length())")
            if HRQueue.length() == Constants.getMaxNumHRQueue() {
                var currentHRs = HRQueue.popAll()
                
                //Don't send if movement
                if let lastMovementDate = Timer.getLastMovementDate() {
                    // don't send notification if movement too recent
                    let timeDifference = NSDate().timeIntervalSinceDate(lastMovementDate)
                    if timeDifference < NSTimeInterval(Constants.getMovementAffectiveDuration()) {
                        return
                    }
                }
                
                Timer.setLastHRSentDate(currentHRs.last!.date)
                
                HRAccumulator.sentHRRequestDate(currentHRs.last!.date)
                
                HTTPRequest.sendHRRequest(currentHRs, self.hrHTTPResponseCallback)
            }
        }
    }
    
    func hrHTTPResponseCallback(response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("(HR) finished sending HR request!")
        if response == nil {
            println("(HR) Request did not go through")
            
            if InternetConnectivity.getInternetConnected() {
                InternetConnectivity.setInternetConnected(false)
                
                Notification.sendNoInternetNotification()
            }
            return
        }
        
        InternetConnectivity.setInternetConnected(true)
        
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
            
            if InternetConnectivity.getInternetConnected() {
                InternetConnectivity.setInternetConnected(false)
                
                Notification.sendNoInternetNotification()
            }
            
            HRAccumulator.startCountdown()
            HRAccumulator.restartCountdown()
            return
        }
        
        InternetConnectivity.setInternetConnected(true)
        
        println("(Stress) finished sending Stress request!")
        println("(Stress) response status code: \(response.statusCode)")
        
        if response.statusCode == 428 {
            if !HRAccumulator.activated() {
                HRAccumulator.startCountdown()
                HRAccumulator.restartCountdown()
            }
        }
        
        if response.statusCode == 200 {
            HRAccumulator.stopCountdown()
            
            let json = data as [String: AnyObject]
            if json["Score"] is Int {
                let score = json["Score"] as Int
                println("(Stress) Received stress score: \(score)")
                self.lastStressScoreInterval.score = score
                self.updatedScoreCallback(interval: self.lastStressScoreInterval)
            }
        }
    }
}