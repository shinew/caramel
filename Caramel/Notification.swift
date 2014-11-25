//
//  Notification.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AVFoundation

let _lowStressMessage = "You seem tense. Let's take a few deep breaths?"
let _highStressMessage = "Need more help on de-stressing? Slide me."
let _noInternetMessage = "We can't seem to connect to the Internet. Try reconnecting?"
let _calibrationCompleteMessage = "Calibration is ready. You can use Beyond now."
let _calibrationSkipMessage = "Please remember to calibrate later."
let _memoryWarningMessage = "Slide me to reconnect."

enum NotificationType {
    case Standard
    case Original
    case LowStress
    case HighStress
}

class Notification {
    
    class func sendMemoryWarningNotification() {
        Notification.sendNotification(_memoryWarningMessage, type: .Original, customSound: nil)
    }
    
    class func sendCalibrationCompleteNotification() {
        Notification.sendNotification(_calibrationCompleteMessage, type: .Standard, customSound: nil)
    }
    
    class func sendCalibrationSkipNotification() {
        Notification.sendNotification(_calibrationSkipMessage, type: .Standard, customSound: nil)
    }
    
    class func sendNoInternetNotification() {
        Notification.sendNotification(_noInternetMessage, type: .Standard, customSound: nil)
    }
    
    class func sendLowStressNotification() {
        Notification.sendNotification(_lowStressMessage, type: .LowStress, customSound: "Realization.wav")
    }
    
    class func sendHighStressNotification() {
        Notification.sendNotification(_highStressMessage, type: .HighStress, customSound: "Realization.wav")
    }
    
    class func sendTestNotification() {
        AppDelegate.setNotificationType(.LowStress)
        var stressNotification = UILocalNotification()
        stressNotification.alertBody = "This is a test stress notification message"
        stressNotification.soundName = "Realization.wav"
        stressNotification.fireDate = NSDate().dateByAddingTimeInterval(5)
        UIApplication.sharedApplication().scheduleLocalNotification(stressNotification)
    }
    
    private class func sendNotification(message: String!, type: NotificationType, customSound: String?) {
        AppDelegate.setNotificationType(type)
        var stressNotification = UILocalNotification()
        stressNotification.alertBody = message
        if let sound = customSound {
            stressNotification.soundName = sound
        } else {
            stressNotification.soundName = UILocalNotificationDefaultSoundName
        }
        stressNotification.fireDate = NSDate() //we send message now
        UIApplication.sharedApplication().scheduleLocalNotification(stressNotification)
    }
}