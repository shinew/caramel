//
//  CalibrationViewController.swift
//  Caramel
//
//  Created by Shine Wang and James Sun on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AudioToolbox

class CalibrationViewController: PortraitViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBAction func refreshButtonDidPress(sender: AnyObject) {
        println("Restart Bluetooth background task")
        AppDelegate.restartBGTask()
    } 
    
    var startDate: NSDate?
    var endDate: NSDate?
    var previousHRCallback: ((NSData!) -> Void)?
    var calibrationCallback = CalibrationCallback()
    var finishedCalibrationTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startButton.layer.cornerRadius = 5
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.whiteColor().CGColor
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        //equivalent to skipCalibrationDidPress
        
        if self.finishedCalibrationTimer != nil {
            self.finishedCalibrationTimer!.invalidate()
            self.finishedCalibrationTimer = nil
        }
        
        HRQueue.popAll()
        
        if self.previousHRCallback != nil {
            HRBluetooth.setHRUpdateCallback(self.previousHRCallback!)
        }
        
        Notification.sendCalibrationSkipNotification()
        return false
    }
    
    @IBAction func startButtonDidPress(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.startButton.enabled = false
        })
        self.startDate = NSDate()
        HRQueue.popAll()
        
        self.previousHRCallback = HRBluetooth.getHRUpdateCallback()
        HRBluetooth.setHRUpdateCallback(self.calibrationCallback.newHeartRateCallback)
        
        self.finishedCalibrationTimer = NSTimer.scheduledTimerWithTimeInterval(305, target: self, selector: Selector("finishedCalibration"), userInfo: nil, repeats: false)
        
        self.startButton.setTitle("We'll vibrate when it's done.", forState: UIControlState.Normal)
        
        self.descriptionTextView.text = "Please don't meditate. Just sit and relax. If you were wondering, Beyond's logo is a pile of three meditation rocks."
        self.descriptionTextView.textColor = UIColor.whiteColor()
        self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
    }
    
    func finishedCalibration() {
        dispatch_async(dispatch_get_main_queue(), {
            self.startButton.enabled = false
            self.skipButton.titleLabel!.text = "Next >"
            self.startButton.setTitle("Perfect. Beyond is ready.", forState: UIControlState.Normal)
            self.descriptionTextView.text = "Just click \"Next\" and let Beyond notify you when you are about to be stressed. It's that easy."
            self.descriptionTextView.textColor = UIColor.whiteColor()
            self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
        })
        
        self.endDate = NSDate()
        var hrSamples = HRQueue.popAll()
        //1 = non-stress, 2 = stress
        var trainingInterval = TrainingInterval(startDate: self.startDate!, endDate: self.endDate!, category: 1, userID: User.getUserID())
        
        HTTPRequest.sendHRRequest(hrSamples, self.calibrationCallback.httpResponseCallbackGenerator("HR"))
        HTTPRequest.sendTrainingIntervalRequest(trainingInterval, self.calibrationCallback.httpResponseCallbackGenerator("Training"))
        
        if self.previousHRCallback != nil {
            HRBluetooth.setHRUpdateCallback(self.previousHRCallback!)
        }
        
        Notification.sendCalibrationCompleteNotification()
        vibratePhone()
    }
    
    private func vibratePhone() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
