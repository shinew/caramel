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
    
    init(type: String!, date: NSDate!) {
        self.type = type
        self.date = date
    }
}