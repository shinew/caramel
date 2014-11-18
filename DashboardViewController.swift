//
//  DashboardViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var dashboardCallback: DashboardCallback!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastEventDurationLabel: UILabel!
    @IBOutlet weak var lastEventTimeLabel: UILabel!
    
    @IBOutlet weak var dailyOverallLabel: UILabel!
    @IBOutlet weak var yesterdayOverallLabel: UILabel!
    @IBOutlet weak var lastStressLabel: UILabel!
    
    @IBOutlet var profileCircleView: ProfileCircleView!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.loadUserIDAndPassword()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        
        self.displayUpdateDateLabels()
        self.updateProfile()

        self.dashboardCallback = DashboardCallback(updatedScoreCallback)
        
        HRBluetooth.setHRUpdateCallback(self.dashboardCallback.newHeartRateCallback)
        
        println("Loaded DashboardViewController view!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refreshButtonDidPress(sender: AnyObject) {
        HRBluetooth.startScanningHRPeripheral()
        println("Restarted Bluetooth services")
    }
    
    private func displayUpdateDateLabels() {
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        self.dayOfTheWeekLabel.text = dateFormatter.stringFromDate(currentDate).uppercaseString
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
        self.dateLabel.text = dateFormatter.stringFromDate(currentDate).uppercaseString
    }
    
    private func updatedScoreCallback(interval: StressScoreInterval!) {
        println("Smooth score: \(interval.score)")
        
        Database.addStressScoreInterval(interval)
        
        self.updateProfile()
        
        self.possiblySendNotification(interval.score)
    }
    
    private func possiblySendNotification(score: Int) {
        println("Determining whether to send a notification or not")
        if score < Constants.getStressNotificationThreshold() {
            return
        }
        
        let currentDate = NSDate()
        
        if let lastMovementDate = Timer.getLastMovementDate() {
            // don't send notification if movement too recent
            let timeDifference = currentDate.timeIntervalSinceDate(lastMovementDate)
            if timeDifference < NSTimeInterval(Constants.getMovementAffectiveDuration()) {
                return
            }
        }
        
        // |low| --- |high| ------------ |low| ------------ |low|
        if let lastLowDate = Timer.getLastLowStressNotifDate() {
            let lowTimeDifference = currentDate.timeIntervalSinceDate(lastLowDate)
            if let lastHighDate = Timer.getLastHighStressNotifDate() {
                let highTimeDifference = currentDate.timeIntervalSinceDate(lastHighDate)
                if lowTimeDifference > NSTimeInterval(Constants.getStressNotificationIntervalDuration()) {
                    
                    Timer.setLastLowStressNotifDate(currentDate)
                    Notification.sendLowStressNotification()
                    Database.addNotificationRecord(NotificationRecord(type: "low", date: currentDate, userID: User.getUserID()))
                    
                } else if highTimeDifference > NSTimeInterval(Constants.getStressNotificationIntervalDuration()) {
                    
                    Timer.setLastHighStressNotifDate(currentDate)
                    Notification.sendHighStressNotification()
                    Database.addNotificationRecord(NotificationRecord(type: "high", date: currentDate, userID: User.getUserID()))
                    
                }
            } else {
                
                Timer.setLastHighStressNotifDate(currentDate)
                Notification.sendHighStressNotification()
                Database.addNotificationRecord(NotificationRecord(type: "high", date: currentDate, userID: User.getUserID()))
                
            }
        } else {
            
            Timer.setLastLowStressNotifDate(currentDate)
            Notification.sendLowStressNotification()
            Database.addNotificationRecord(NotificationRecord(type: "low", date: currentDate, userID: User.getUserID()))
            
        }
    }
    
    private func updateProfile() {
        println("Updating profile circle and daily score")
        let currentDate = NSDate()
        let startDate = Conversion.dateToTimelessDate(currentDate)
        let endDate = startDate.dateByAddingTimeInterval(60 * 60 * 24) //add 24hrs
        
        let stressIntervals = Database.getSortedStressIntervals(startDate, endDate: endDate)
        let notifRecords = Database.getSortedNotificationRecords(startDate, endDate: endDate)

        //updates current and lastStress scores
        self.displayLastStressScores(stressIntervals)
        
        //updates profile circle
        let scores = self.prepareStressScoresForCircle(startDate, endDate: endDate, stressIntervals: stressIntervals)
        self.profileCircleView.setStressScores(scores)
        self.profileCircleView.setNeedsDisplay()
        
        //updates daily wellness scores
        
        let newDailyScore = self.calculateDailyScore(stressIntervals, notifRecords: notifRecords)
        if newDailyScore != nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.dailyOverallLabel.text = String(newDailyScore!)
            })
            Database.updateDailyWellnessScore(DailyWellnessScore(date: startDate, score: newDailyScore!, userID: User.getUserID()))
        }
        
        let yesterdayDailyScore = Database.getDailyWellnessScore(DailyWellnessScore(
            date: currentDate.dateByAddingTimeInterval(-60 * 60 * 24),
            score: 0,
            userID: User.getUserID()
        ))
        if yesterdayDailyScore != nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.yesterdayOverallLabel.text = String(yesterdayDailyScore!.score)
            })
        }
    }
    
    private func displayLastStressScores(stressIntervals: [StressScoreInterval]) {
        if stressIntervals.count == 0 {
            return
        }
        var lastStressDuration = 0
        var updatedStressLabel = false
        for var i = stressIntervals.count - 1; i >= 0; i-- {
            let stressInterval = stressIntervals[i]
            if stressInterval.score >= Constants.getStressNotificationThreshold() {
                lastStressDuration += 30
                if !updatedStressLabel {
                    updatedStressLabel = true
                    dispatch_async(dispatch_get_main_queue(), {
                        self.lastStressLabel.text = "\(stressInterval.score)"
                    })
                }
            } else {
                if updatedStressLabel {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.lastEventTimeLabel.text = Conversion.dateToTimeString(stressInterval.startDate)
                    })
                    self.displayStressDuration(lastStressDuration)
                    return
                }
            }
        }
        if updatedStressLabel {
            dispatch_async(dispatch_get_main_queue(), {
                self.lastEventTimeLabel.text = Conversion.dateToTimeString(stressIntervals[0].startDate)
            })
            self.displayStressDuration(lastStressDuration)
            return
        }
    }
    
    private func displayStressDuration(duration: Int) {
        if duration > 3600 {
            dispatch_async(dispatch_get_main_queue(), {
                self.lastEventDurationLabel.text = "\(duration / 3600) hr"
            })

        } else if duration > 60 {
            dispatch_async(dispatch_get_main_queue(), {
                self.lastEventDurationLabel.text = "\(duration / 60) min"
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.lastEventDurationLabel.text = "\(duration) s"
            })
        }
    }
    
    private func prepareStressScoresForCircle(startDate: NSDate!, endDate: NSDate!, stressIntervals: [StressScoreInterval]) -> [Int?] {
        println("Calculating circle update array")
        var result = [Int?]()
        let circleArcRange = NSTimeInterval(Constants.getProfileCircleFineness() * 60)
        var index = 0
        var currentStartDate = startDate
        while currentStartDate.compare(endDate) == NSComparisonResult.OrderedAscending {
            //we take the maximum over that range as the display
            let currentEndDate = currentStartDate.dateByAddingTimeInterval(circleArcRange)
            var maxScore: Int?
            //we want start <= scoreStartDate < end
            while index < stressIntervals.count &&
                currentStartDate.compare(stressIntervals[index].startDate) != NSComparisonResult.OrderedDescending &&
                currentEndDate.compare(stressIntervals[index].startDate) == NSComparisonResult.OrderedDescending {
                    if maxScore == nil {
                        maxScore = stressIntervals[index].score
                    } else {
                        maxScore = max(maxScore!, stressIntervals[index].score)
                    }
                    index++
            }
            result.append(maxScore)
            currentStartDate = currentEndDate
        }
        return result
    }

    private func calculateDailyScore(stressIntervals: [StressScoreInterval], notifRecords: [NotificationRecord]) -> Int? {
        println("Calculating and displaying daily overall score")
        if stressIntervals.count == 0 {
            return nil
        }
        var score = 0.0
        var stressScores = [Int]()
        var lowNotifCount = 0
        var highNotifCount = 0
        for interval in stressIntervals {
            stressScores.append(interval.score)
        }
        for record in notifRecords {
            if record.type == "low" {
                lowNotifCount++
            } else {
                highNotifCount++
            }
        }

        score += Math.stddev(stressScores) / 30.0 * 25.0
        score += Double(lowNotifCount) / 6.0 * 25.0
        score += Double(highNotifCount) / 3.0 * 25.0
        score += Math.rms(stressScores) / 100.0 * 25.0
        score = min(99.0, score)
        score = max(1.0, score)
        var wellnessScore = Int(100.0 - score)
        return wellnessScore
    }
}