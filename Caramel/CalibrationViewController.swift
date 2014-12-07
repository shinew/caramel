//
//  CalibrationViewController.swift
//  Caramel
//
//  Created by Shine Wang and James Sun on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AudioToolbox

var _trainingInterval: TrainingInterval!

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
    var bluetoothConnectivity = BluetoothConnectivity()
    var disconnectCount = 0
    var lastBluetoothResetTime: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startButton.layer.cornerRadius = 5
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.bluetoothConnectivity.setCallbacks(
            {(Void) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if self.descriptionTextView == nil || self.disconnectCount == 0 {
                        return
                    }
                    self.descriptionTextView.text = "Your Wahoo has been reconnected."
                    self.descriptionTextView.textColor = UIColor.whiteColor()
                    self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
                    
                    self.startButton.enabled = true
                })
            },
            disconnectedCallback: {(Void) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if self.descriptionTextView == nil {
                        return
                    }
                    self.descriptionTextView.text = "Your Wahoo has to be connected for calibration. Click on the top right button to reconnect or re-snap the chest strap."
                    self.descriptionTextView.textColor = UIColor.whiteColor()
                    self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
                    
                    self.startButton.enabled = false
                })
                
                self.disconnectCount++
                
                if self.lastBluetoothResetTime == nil || NSDate().timeIntervalSinceDate(self.lastBluetoothResetTime!) < Constants.getBluetoothReconnectInterval() {
                    return
                }
                self.lastBluetoothResetTime = NSDate()
                
                println("(BLConnect) Restarting HRBluetooth")
                
                HRAccumulator.startCountdown()
                HRAccumulator.restartCountdown()
                AppDelegate.restartBGTask()
            }
        )
        
        self.bluetoothConnectivity.setLongRunningTimer()
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
        CalibrationState.setCalibrationState(false)
        self.disconnectCount = 0
        
        if self.finishedCalibrationTimer != nil {
            self.finishedCalibrationTimer!.invalidate()
            self.finishedCalibrationTimer = nil
        }
        
        HRQueue.popAll()
        
        if self.previousHRCallback != nil {
            HRBluetooth.setHRUpdateCallback(self.previousHRCallback!)
        }
        
        Notification.sendCalibrationSkipNotification()
        
        self.resetCalibrationPage()
        
        return false
    }
    
    private func resetCalibrationPage() {
        dispatch_async(dispatch_get_main_queue(), {
            self.descriptionTextView.text = "Beyond needs five minutes to understand your body. Let's relax for five minutes without controlling your breath."
            self.descriptionTextView.textColor = UIColor.whiteColor()
            self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
            self.startButton.setTitle("Start Now.", forState: UIControlState.Normal)
            self.startButton.enabled = true
            self.skipButton.setTitle("Skip >", forState: UIControlState.Normal)
        })
    }
    
    @IBAction func startButtonDidPress(sender: AnyObject) {
        CalibrationState.setCalibrationState(true)
        self.disconnectCount = 0
        
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
        User.attemptedCalibration()
        CalibrationState.setCalibrationState(false)
        self.disconnectCount = 0
        
        dispatch_async(dispatch_get_main_queue(), {
            self.skipButton.setTitle("Next >", forState: UIControlState.Normal)
            self.startButton.setTitle("Perfect. Beyond is ready.", forState: UIControlState.Normal)
            self.descriptionTextView.text = "Just click \"Next\" and let Beyond notify you when you are about to be stressed. It's that easy."
            self.descriptionTextView.textColor = UIColor.whiteColor()
            self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
        })
        
        self.endDate = NSDate()
        var hrSamples = HRQueue.popAll()
        //1 = non-stress, 2 = stress
        _trainingInterval = TrainingInterval(startDate: self.startDate!, endDate: self.endDate!, category: 1, userID: User.getUserID())
        
        HTTPRequest.sendHRRequest(hrSamples, self.httpHRResponseCallback)
        
        if self.previousHRCallback != nil {
            HRBluetooth.setHRUpdateCallback(self.previousHRCallback!)
        }
        
        vibratePhone()
    }
    
    func httpHRResponseCallback (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
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
        HTTPRequest.sendTrainingIntervalRequest(_trainingInterval, self.httpTrainingResponseCallback)
    }
    
    func httpTrainingResponseCallback (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void {
        println("(Training) finished sending Training request!")
        if response == nil {
            println("(Training) Request did not go through")
            
            if InternetConnectivity.getInternetConnected() {
                InternetConnectivity.setInternetConnected(false)
                
                Notification.sendNoInternetNotification()
            }
            return
        }
        
        InternetConnectivity.setInternetConnected(true)
        
        println("(Training) response status code: \(response.statusCode)")
        
        var callback = DashboardCallback.getReloadDashboardScreenCallback()
        if callback != nil {
            HTTPRequest.sendUserCalibrationCountRequest(UserRecord(userName: nil, userID: User.getUserID(), password: User.getPassword()), responseCallback: callback!)
        }
        
        Notification.sendCalibrationCompleteNotification()
    }
    
    private func vibratePhone() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
