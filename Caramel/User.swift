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

class User {
    class func getUserID() -> Int {
        return _userID
    }
    
    class func getPassword() -> String {
        return _password
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
    }
}