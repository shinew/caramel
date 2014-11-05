//
//  NotificationRecord.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-03.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct NotificationRecord {

    var type: String
    var date: NSDate
    var userID: Int
    
    init(type: String!, date: NSDate!, userID: Int!) {
        self.type = type
        self.date = date
        self.userID = userID
    }
}