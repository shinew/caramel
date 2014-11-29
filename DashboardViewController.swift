//
//  DashboardViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class DashboardViewController: PortraitViewController {
    
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
    
    @IBOutlet weak var countdownHRLabel: UILabel!
    @IBOutlet weak var countdownDescriptionLabel: UILabel!

    @IBOutlet weak var needsCalibrationView: UIView!
    
    var bluetoothConnectivity = BluetoothConnectivity()
    var summaryToggle = 0
    
    required override init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateProfile()
        self.registerZoneTapToggles()
        
        self.dashboardCallback = DashboardCallback(
            updatedScoreCallback: self.updatedScoreCallback,
            currentHRLabel: self.currentHRLabel,
            countdownHRLabel: self.countdownHRLabel,
            countdownDescriptionLabel: self.countdownDescriptionLabel,
            needsCalibrationView: self.needsCalibrationView
        )
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let lastSentDate = Timer.getLastMemoryWarningNotificationDate()
        if lastSentDate == nil {
            BackgroundSuspension.setMemoryWarningSent(true)
            Timer.setLastMemoryWarningNotificationDate(NSDate())
            Notification.sendMemoryWarningNotification()
            return
        }
        
        if lastSentDate!.timeIntervalSinceNow <= (0.0 - Constants.getMemoryWarningThrottleDuration()) && !BackgroundSuspension.getMemoryWarningSent() {
            BackgroundSuspension.setMemoryWarningSent(true)
            Timer.setLastMemoryWarningNotificationDate(NSDate())
            Notification.sendMemoryWarningNotification()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), {
            self.needsCalibrationView.hidden = false
        })
        
        if User.getHasCalibrated() {
            dispatch_async(dispatch_get_main_queue(), {
                self.needsCalibrationView.hidden = true
            })
        } else {
            User.loadCalibrationData(self.dashboardCallback.loadCalibrationDataCallback)
        }
    }
    
    func registerZoneTapToggles() {
        var zoneViews = [self.blueZoneView, self.yellowZoneView, self.redZoneView]
        
        for i in 0 ..< zoneViews.count {
            zoneViews[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handleTap:")))
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        println("A zone has been tapped")
        self.summaryToggle = 1 - self.summaryToggle
        self.updateProfile()
    }

    @IBAction func refreshButtonDidPress(sender: AnyObject) {
        println("Restart Bluetooth background task")
        AppDelegate.restartBGTask()
    }
    
    private func updatedScoreCallback(interval: StressScoreInterval!) {
        println("Raw score: \(interval.score)")
        
        var smoothInterval = StressScoreManager.addRawScore(interval)
        StressScoreManager.possiblySendNotification(smoothInterval.score)
        
        Database.addStressScoreInterval(smoothInterval)
        
        self.updateProfile()
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
        var counters = [0, 0, 0]
        var labels = [self.blueZoneLabel, self.yellowZoneLabel, self.redZoneLabel]
        var timeFormatLabels = [self.blueZoneTimeFormatLabel, self.yellowZoneTimeFormatLabel, self.redZoneTimeFormatLabel]
        var colors = ["Blue", "Yellow", "Red"]
        
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
                self.updateTimeLabels(
                    self.summaryToggle,
                    counter: counters[i],
                    total: total,
                    label: labels[i],
                    timeFormatLabel: timeFormatLabels[i]
                )
            })
        }
    }
    
    private func updateTimeLabels(toggle: Int, counter: Int, total: Int, label: UILabel!, timeFormatLabel: UILabel!) {
        if toggle == 0 {
            var seconds = counter * 30 //roughly
            if total == 0 {
                timeFormatLabel.text = "sec"
            } else if seconds < 60 {
                label.text = "\(seconds)"
                timeFormatLabel.text = "sec"
            } else if seconds < 3600 {
                label.text = "\(seconds / 60)"
                timeFormatLabel.text = "min"
            } else if seconds == 3600 {
                label.text = "1:00"
                timeFormatLabel.text = "hour"
            } else {
                var minutes = String(format: "%02d", (seconds % 3600) / 60)
                label.text = "\(seconds / 3600):\(minutes)"
                timeFormatLabel.text = "hours"
            }
        } else {
            timeFormatLabel.text = "%"
            if total != 0 {
                label.text = "\(Int(Double(counter)/Double(total)*100.0))"
            }
        }
    }
}