//
//  User.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-05.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct UserRecord {
    
    var userID: Int?
    var userName: String?
    var password: String?
    
    init(userName: String?, userID: Int?, password: String?) {
        self.userName = userName
        self.userID = userID
        self.password = password
    }
}