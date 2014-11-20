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
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        
        self.updateProfile()

        self.dashboardCallback = DashboardCallback(updatedScoreCallback)
        
        HRBluetooth.setHRUpdateCallback(self.dashboardCallback.newHeartRateCallback)
        
        println("Loaded DashboardViewController view!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func refreshButtonDidPress(sender: AnyObject) {
        println("Restart Bluetooth background task")
        AppDelegate.restartBGTask()
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
    }
}