//
//  Notification.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-30.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AVFoundation

class Notification {
    
    class func sendStressNotification(var stressScore: Int) {
        //possibly customize to delay notification
        var stressNotification = UILocalNotification()
        stressNotification.alertBody = "Hey, your current stress score is \(stressScore)"
        stressNotification.soundName = UILocalNotificationDefaultSoundName
        stressNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(stressNotification)
    }
}