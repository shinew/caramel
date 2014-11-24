//
//  StressScoreManager.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-22.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _scoreSmootheningScore = ScoreSmootheningQueue()
var _currentInterval = Double(Constants.getDefaultStressNotificationInterval())
var _stressScoreQueue = [Int]()
var _addToScoreQueue = false
var _rawScoreCallbacks = Dictionary<String, (StressScoreInterval!) -> Void>()

class StressScoreManager {
    
    class func addRawScoreCallback(key: String, callback: (StressScoreInterval!) -> Void) {
        _rawScoreCallbacks[key] = callback
    }
    
    class func addRawScore(score: StressScoreInterval) -> StressScoreInterval {
        for (key, callback) in _rawScoreCallbacks {
            callback(score)
        }
        return  _scoreSmootheningScore.addRawScore(score)
    }
    
    class func possiblySendNotification(score: Int) -> Bool {
        
        let lastNotifDate = Timer.getLastStressNotifDate()
        
        if !_addToScoreQueue {
            if lastNotifDate != nil && lastNotifDate!.timeIntervalSinceNow > (0.0 - _currentInterval) {
                return false
            }
            
            if score < Constants.getStressNotificationThreshold() {
                return false
            }
            _addToScoreQueue = true
            _stressScoreQueue.append(score)
            Timer.setLastStressNotifDate(NSDate())
            Notification.sendLowStressNotification()
            return true
        } else {
            if lastNotifDate!.timeIntervalSinceNow <= (0.0 - Double(Constants.getStressDiscardInterval())) {
                //we discard 5 min after last notification
                _stressScoreQueue.append(score)
            }
            
            if lastNotifDate!.timeIntervalSinceNow > (0.0 - _currentInterval) {
                return false
            }
            if score < Constants.getStressNotificationThreshold() {
                _addToScoreQueue = false
                _currentInterval = Double(Constants.getDefaultStressNotificationInterval()) * 2.0
                _stressScoreQueue = [Int]()
                return false
            }
            
            let currentDate = NSDate()
            
            Timer.setLastStressNotifDate(currentDate)
            _currentInterval *= 1.5
            
            if StressScoreManager.isMajorityStressed() {
                Notification.sendHighStressNotification()
                Database.addNotificationRecord(NotificationRecord(type: "high", date: currentDate, userID: User.getUserID()))
                
            } else {
                Notification.sendLowStressNotification()
                Database.addNotificationRecord(NotificationRecord(type: "low", date: currentDate, userID: User.getUserID()))
            }
            
            return true
        }
    }
    
    private class func isMajorityStressed() -> Bool {
        var stressCount = 0
        for score in _stressScoreQueue {
            if score >= Constants.getStressNotificationThreshold() {
                stressCount++
            }
        }
        if stressCount > _stressScoreQueue.count / 2 {
            return true
        } else {
            return false
        }
    }
}
