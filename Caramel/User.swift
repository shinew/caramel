//
//  User.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-04.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _userID = 9000
var _password = "password"
var _hasCalibrated = false
var _hasAttemptedCalibration = false

class User {
    class func getUserID() -> Int {
        return _userID
    }
    
    class func getPassword() -> String {
        return _password
    }
    
    class func getHasCalibrated() -> Bool {
        return _hasCalibrated
    }
    
    class func getHasAttemptedCalibration() -> Bool {
        return _hasAttemptedCalibration
    }
    
    class func setHasCalibrated(calibrated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        _hasCalibrated = calibrated
        defaults.setBool(_hasCalibrated, forKey: "hasCalibrated")
    }
    
    class func setUserIDAndPassword(userID: Int, password: String) {
        _userID = userID
        _password = password
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(_userID, forKey: "userID")
        defaults.setObject(_password, forKey: "password")
    }
    
    class func loadUserIDAndPassword() {
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.integerForKey("userID") != 0 {
            _userID = defaults.integerForKey("userID")
        }
        if let password: AnyObject = defaults.objectForKey("password") {
            _password = password as String
        }
        _hasCalibrated = defaults.boolForKey("hasCalibrated")
        _hasAttemptedCalibration = defaults.boolForKey("hasAttemptedCalibration")
    }
    
    class func loadCalibrationData(response: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void) {
        var defaults = NSUserDefaults.standardUserDefaults()
        HTTPRequest.sendUserCalibrationCountRequest(
            UserRecord(userName: nil, userID: _userID, password: _password),
            responseCallback: response
        )
    }
    
    class func attemptedCalibration() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasAttemptedCalibration")
        _hasAttemptedCalibration = true
    }
}