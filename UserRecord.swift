//
//  User.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-05.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct UserRecord {
    
    var firstName: String
    var lastName: String?
    var userID: Int?
    var password: String?
    
    init(firstName: String, lastName: String?, userID: Int?, password: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.userID = userID
        self.password = password
    }
}