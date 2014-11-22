//
//  DebugViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-03.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

var _registeredDebugCallback = false

class DebugViewController: UIViewController {

    @IBOutlet weak var hrvLabel: UILabel!
    @IBOutlet weak var stressScoreLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var movementLabel: UILabel!
    
    @IBOutlet weak var testNotificationButton: UIButton!
    
    @IBOutlet weak var getUserIDButton: UIButton!
    @IBOutlet weak var userIDLabel: UILabel!
    
    
    @IBAction func getUserIDButtonDidPress(sender: AnyObject) {
        self.userIDLabel.text = "\(User.getUserID())"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !_registeredDebugCallback {
            _registeredDebugCallback = true
            self.registerCallbacks()
        }
    }
    
    private func registerCallbacks() {
        //add the callbacks to the global queues
        StressQueue.addNewScoreCallback(self.updatedScoreCallback)
        HRQueue.addNewHRCallback(self.updatedHRCallback)
        Movement.addNewMovementCallback(self.updatedMovementCallback)
    }
    
    private func updatedScoreCallback(interval: StressScoreInterval!) {
        println("(Debug) Updated score: \(interval.score)")
        dispatch_async(dispatch_get_main_queue(), {
            self.stressScoreLabel.text = "\(interval.score)"
        })
    }
    
    private func updatedHRCallback(sample: HRSample!) {
        println("(Debug) Updated HR: \(sample)")
        dispatch_async(dispatch_get_main_queue(), {
            if sample.hr == nil {
                self.heartRateLabel.text = "None"
            } else {
                self.heartRateLabel.text = "\(sample.hr!)"
            }
            if sample.hrv == nil {
                self.hrvLabel.text = "None"
            } else {
                self.hrvLabel.text = "\(sample.hrv!)"
            }
        })
    }

    private func updatedMovementCallback(wasMoving: Bool) {
        println("(Debug) Updated Movement: \(wasMoving)")
        dispatch_async(dispatch_get_main_queue(), {
            if wasMoving == true {
                self.movementLabel.text = "Moving"
            } else {
                self.movementLabel.text = "Still"
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func testNotificationButtonDidPress(sender: UIButton) {
        AppDelegate.setNotificationType(.LowStress)
        var stressNotification = UILocalNotification()
        stressNotification.alertBody = "This is a test stress notification message"
        stressNotification.soundName = UILocalNotificationDefaultSoundName
        stressNotification.fireDate = NSDate().dateByAddingTimeInterval(5)
        UIApplication.sharedApplication().scheduleLocalNotification(stressNotification)
    }
}
