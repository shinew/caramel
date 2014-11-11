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

class Notification {
    
    class func sendNoInternetNotification() {
        Notification.sendNotification(_noInternetMessage)
    }
    
    class func sendLowStressNotification() {
        Notification.sendNotification(_lowStressMessage)
    }
    
    class func sendHighStressNotification() {
        Notification.sendNotification(_highStressMessage)
    }
    
    private class func sendNotification(message: String!) {
        var stressNotification = UILocalNotification()
        stressNotification.alertBody = message
        stressNotification.soundName = UILocalNotificationDefaultSoundName
        stressNotification.fireDate = NSDate() //we send message now
        UIApplication.sharedApplication().scheduleLocalNotification(stressNotification)
    }
}