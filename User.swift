//
//  User.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _id: Int = 9000
var _password: String = "password"
var _firstName: String?
var _lastName: String?

class User {
    
    class func setIDPassword(id: Int!, password: String!) {
        _id = id
        _password = password
    }
    
    class func getID() -> Int {
        //switch to using a database!
        return _id
    }
    
    class func getPassword() -> String {
        return _password
    }
}