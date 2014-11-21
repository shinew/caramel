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
    
    @IBOutlet weak var redZoneLabel: UILabel!
    @IBOutlet weak var yellowZoneLabel: UILabel!
    @IBOutlet weak var blueZoneLabel: UILabel!
    @IBOutlet weak var percentDayStressLabel: UILabel!
    @IBOutlet weak var currentHRLabel: UILabel!
    @IBOutlet weak var redZoneTimeLabel: UILabel!
    @IBOutlet weak var yellowZoneTimeLabel: UILabel!
    @IBOutlet weak var blueZoneTimeLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var bluetoothConnectivity = BluetoothConnectivity()
    
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

        self.dashboardCallback = DashboardCallback(updatedScoreCallback: self.updatedScoreCallback, currentHRLabel: self.currentHRLabel)
        
        HRBluetooth.setHRUpdateCallback(self.dashboardCallback.newHeartRateCallback)
        
        //start timer
        self.bluetoothConnectivity.setCallbacks({(Void) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
            })}, disconnectedCallback: {(Void) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.currentHRLabel.text = "Disconnected"
                    self.currentHRLabel.font = UIFont(name: "Univers Light Condensed", size: 18)
            })}
        )
        self.bluetoothConnectivity.setLongRunningTimer()
        
        
        println("Loaded DashboardViewController view!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Notification.sendMemoryWarningNotification()
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
        
        let stressIntervals = Database.getSortedStressIntervals(startDate, endDate: endDate)
        self.updateZonePercentages(stressIntervals)
    }
    
    private func updateZonePercentages(stressIntervals: [StressScoreInterval]!) {
        if stressIntervals.count == 0 {
            return
        }
        
        var counters = [0, 0, 0]
        var labels = [self.blueZoneLabel, self.yellowZoneLabel, self.redZoneLabel]
        var timeFormatLabels = [self.blueZoneTimeLabel, self.yellowZoneTimeLabel, self.redZoneTimeLabel]
        
        for interval in stressIntervals {
            if interval.score < Constants.getCircleColorYellowThreshold() {
                counters[0]++
            } else if interval.score < Constants.getCircleColorRedThreshold() {
                counters[1]++
            } else {
                counters[2]++
            }
        }
        let total = reduce(counters, 0, {(old: Int, next: Int) in return old + next})
        
        for i in 0 ..< labels.count {
            dispatch_async(dispatch_get_main_queue(), {
                self.updateTimeLabels(counters[i], label: labels[i], timeFormatLabel: timeFormatLabels[i])
            })
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.percentDayStressLabel.text = "\(Int(Double(counters[1]+counters[2])/Double(total)*100.0))"
        })
    }
    
    private func updateTimeLabels(counter: Int, label: UILabel!, timeFormatLabel: UILabel!) {
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
            label.text = "\(seconds / 3600):\((seconds % 3600)/60)"
            timeFormatLabel.text = "hours"
        }
    }
}