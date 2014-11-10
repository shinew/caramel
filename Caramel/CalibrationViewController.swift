//
//  CalibrationViewController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class CalibrationViewController: UIViewController {
    
    var startDate: NSDate?
    var endDate: NSDate?
    var previousHRCallback: ((NSData!) -> Void)?
    var calibrationCallback = CalibrationCallback()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startButtonDidPress() {
        //refactor this into the IBAction outlet later
        self.startDate = NSDate()
        HRQueue.popAll()
        
        self.previousHRCallback = HRBluetooth.getHRUpdateCallback()
        HRBluetooth.setHRUpdateCallback(self.calibrationCallback.newHeartRateCallback)
    }
    
    func endButtonDidPress() {
        self.endDate = NSDate()
        var hrSamples = HRQueue.popAll()
        //1 = non-stress, 2 = stress
        var trainingInterval = TrainingInterval(startDate: self.startDate!, endDate: self.endDate!, category: 1, userID: User.getUserID())
        
        HTTPRequest.sendHRRequest(hrSamples, self.calibrationCallback.httpResponseCallbackGenerator("HR"))
        HTTPRequest.sendTrainingIntervalRequest(trainingInterval, self.calibrationCallback.httpResponseCallbackGenerator("Training"))
    }
}
