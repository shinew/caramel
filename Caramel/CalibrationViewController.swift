//
//  CalibrationViewController.swift
//  Caramel
//
//  Created by Shine Wang and James Sun on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AudioToolbox

class CalibrationViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var startDate: NSDate?
    var endDate: NSDate?
    var previousHRCallback: ((NSData!) -> Void)?
    var calibrationCallback = CalibrationCallback()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        }

        self.startButton.layer.cornerRadius = 5
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        //equivalent to skipCalibrationDidPress
        
        dispatch_async(dispatch_get_main_queue(), {
            self.startButton.enabled = false
        })
        HRQueue.popAll()
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
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(305, target: self, selector: Selector("endButtonDidPress"), userInfo: nil, repeats: false)
        
        self.startButton.setTitle("We'll vibrate when it's done.", forState: UIControlState.Normal)
        
        self.descriptionTextView.text = "Please don't meditate. Just sit and relax. If you were wondering, Beyond's logo is a pile of three meditation rocks."
        self.descriptionTextView.textColor = UIColor.whiteColor()
        self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
    }
    
    private func vibratePhone() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func endButtonDidPress() {
        dispatch_async(dispatch_get_main_queue(), {
            self.startButton.enabled = false
        })
        
        self.endDate = NSDate()
        var hrSamples = HRQueue.popAll()
        //1 = non-stress, 2 = stress
        var trainingInterval = TrainingInterval(startDate: self.startDate!, endDate: self.endDate!, category: 1, userID: User.getUserID())
        
        HTTPRequest.sendHRRequest(hrSamples, self.calibrationCallback.httpResponseCallbackGenerator("HR"))
        HTTPRequest.sendTrainingIntervalRequest(trainingInterval, self.calibrationCallback.httpResponseCallbackGenerator("Training"))
        
        HRBluetooth.setHRUpdateCallback(self.previousHRCallback!)
        
        self.startButton.setTitle("Perfect. Beyond is ready.", forState: UIControlState.Normal)
        self.descriptionTextView.text = "Just exit the app and let Beyond notify you when you are about to be stressed. It's that easy."
        self.descriptionTextView.textColor = UIColor.whiteColor()
        self.descriptionTextView.font = UIFont(name: "Univers-Light-Normal", size: 17)
        
        Notification.sendCalibrationCompleteNotification()
        vibratePhone()
    }
}
