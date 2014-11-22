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
    
    @IBOutlet weak var redZoneView: UIView!
    @IBOutlet weak var yellowZoneView: UIView!
    @IBOutlet weak var blueZoneView: UIView!
    
    @IBOutlet weak var redZoneLabel: UILabel!
    @IBOutlet weak var yellowZoneLabel: UILabel!
    @IBOutlet weak var blueZoneLabel: UILabel!

    @IBOutlet weak var redZoneTimeFormatLabel: UILabel!
    @IBOutlet weak var yellowZoneTimeFormatLabel: UILabel!
    @IBOutlet weak var blueZoneTimeFormatLabel: UILabel!

    @IBOutlet weak var percentTodayStressLabel: UILabel!
    @IBOutlet weak var percentYesterdayStressLabel: UILabel!
    @IBOutlet weak var currentHRLabel: UILabel!

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var bluetoothConnectivity = BluetoothConnectivity()
    var summaryToggle = 0
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Univers-Light-Bold",
                size: 18
        )!]
        
        self.updateProfile()
        self.registerZoneTapToggle()
        
        self.dashboardCallback = DashboardCallback(updatedScoreCallback: self.updatedScoreCallback, currentHRLabel: self.currentHRLabel)
        
        HRBluetooth.setHRUpdateCallback(self.dashboardCallback.newHeartRateCallback)
        
        //start timer
        self.bluetoothConnectivity.setCallbacks(
            nil,
            disconnectedCallback: {(Void) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if self.currentHRLabel != nil {
                        self.currentHRLabel.text = "Disconnected"
                        self.currentHRLabel.font = UIFont(name: "Univers Light Condensed", size: 18)
                    }
            })}
        )
        self.bluetoothConnectivity.setLongRunningTimer()
        
        
        println("Loaded DashboardViewController view!")
    }
    
    func registerZoneTapToggle() {
        var zoneViews = [self.blueZoneView, self.yellowZoneView, self.redZoneView]
        for zoneView in zoneViews {
            zoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handleTap:")))
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        println("A zone has been tapped")
        self.summaryToggle = 1 - self.summaryToggle
        self.updateProfile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let lastSentDate = Timer.getLastMemoryWarningNotificationDate()
        if lastSentDate != nil && lastSentDate!.timeIntervalSinceNow <= (0.0 - Constants.getMemoryWarningThrottleDuration()) {
            Timer.setLastMemoryWarningNotificationDate(NSDate())
            Notification.sendMemoryWarningNotification()
        }
    }
    
    @IBAction func refreshButtonDidPress(sender: AnyObject) {
        println("Restart Bluetooth background task")
        AppDelegate.restartBGTask()
    }
    
    private func updatedScoreCallback(interval: StressScoreInterval!) {
        println("Smooth score: \(interval.score)")
        
        if let lastMovementDate = Timer.getLastMovementDate() {
            // don't send notification if movement too recent
            let timeDifference = NSDate().timeIntervalSinceDate(lastMovementDate)
            if timeDifference < NSTimeInterval(Constants.getMovementAffectiveDuration()) {
                return
            }
        }
        
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
        
        // |low| --- |high| ------------ |low| ------------ |low|
        if let lastLowDate = Timer.getLastLowStressNotifDate() {
            let lowTimeDifference = currentDate.timeIntervalSinceDate(lastLowDate)
            if let lastHighDate = Timer.getLastHighStressNotifDate() {
                let highTimeDifference = currentDate.timeIntervalSinceDate(lastHighDate)
                let highLowTimeDifference = currentDate.timeIntervalSinceDate(lastLowDate)
                
                if lowTimeDifference > NSTimeInterval(Constants.getStressNotificationIntervalDuration()) {
                    
                    Timer.setLastLowStressNotifDate(currentDate)
                    Notification.sendLowStressNotification()
                    Database.addNotificationRecord(NotificationRecord(type: "low", date: currentDate, userID: User.getUserID()))
                    
                } else if highTimeDifference > NSTimeInterval(Constants.getStressNotificationIntervalDuration()) &&
                    highLowTimeDifference > NSTimeInterval(Constants.getHighStressNotificationIntervalDuration())
                {
                    
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
        println("Updating dashboard numbers")
        let currentDate = NSDate()
        let startDate = Conversion.dateToTimelessDate(currentDate)
        let endDate = startDate.dateByAddingTimeInterval(60 * 60 * 24) //add 24hrs
        let yesterdayStartDate = startDate.dateByAddingTimeInterval(-60 * 60 * 24)
        
        let todayStressIntervals = Database.getSortedStressIntervals(startDate, endDate: endDate)
        let yesterdayStressIntervals = Database.getSortedStressIntervals(yesterdayStartDate, endDate: startDate)
        
        self.updateZonePercentages(todayStressIntervals)
        
        let todayPercent = self.getDailyPercentStress(todayStressIntervals)
        let yesterdayPercent = self.getDailyPercentStress(yesterdayStressIntervals)
        dispatch_async(dispatch_get_main_queue(), {
            if todayPercent != nil {
                self.percentTodayStressLabel.text = String(todayPercent!)
            }
            if yesterdayPercent != nil {
                self.percentYesterdayStressLabel.text = String(yesterdayPercent!)
            }
        })
    }
    
    private func getDailyPercentStress(stressIntervals: [StressScoreInterval]!) -> Int? {
        if stressIntervals.count == 0 {
            return nil
        }
        var stressCounter = 0
        for interval in stressIntervals {
            if interval.score >= Constants.getCircleColorYellowThreshold() {
                stressCounter++
            }
        }
        return Int(Double(stressCounter)/Double(stressIntervals.count)*100.0)
    }
    
    private func updateZonePercentages(stressIntervals: [StressScoreInterval]!) {
        if stressIntervals.count == 0 {
            return
        }
        
        var counters = [0, 0, 0]
        var labels = [self.blueZoneLabel, self.yellowZoneLabel, self.redZoneLabel]
        var timeFormatLabels = [self.blueZoneTimeFormatLabel, self.yellowZoneTimeFormatLabel, self.redZoneTimeFormatLabel]
        
        for interval in stressIntervals {
            if interval.score < Constants.getCircleColorYellowThreshold() {
                counters[0]++
            } else if interval.score < Constants.getCircleColorRedThreshold() {
                counters[1]++
            } else {
                counters[2]++
            }
        }
        let total = stressIntervals.count
        
        for i in 0 ..< labels.count {
            dispatch_async(dispatch_get_main_queue(), {
                self.updateTimeLabels(counters[i], total: total, label: labels[i], timeFormatLabel: timeFormatLabels[i])
            })
        }
    }
    
    private func updateTimeLabels(counter: Int, total: Int, label: UILabel!, timeFormatLabel: UILabel!) {
        if self.summaryToggle == 0 {
            var seconds = counter * 30 //roughly
            if seconds < 60 {
                label.text = "\(seconds)"
                timeFormatLabel.text = "sec"
            } else if seconds < 3600 {
                label.text = "\(seconds / 60)"
                timeFormatLabel.text = "min"
            } else if seconds == 3600 {
                label.text = "1:00"
                timeFormatLabel.text = "hour"
            } else {
                label.text = "\(seconds / 3600):\((seconds % 3600) / 60)"
                timeFormatLabel.text = "hours"
            }
        } else {
            label.text = "\(Int(Double(counter)/Double(total)*100.0))"
            timeFormatLabel.text = "%"
        }
    }
}