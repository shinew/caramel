//
//  TrainingInterval.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct TrainingInterval {
    
    var startDate: NSDate
    var endDate: NSDate
    var category: Int
    var isDefaultSet: Bool
    var userID: Int
    
    init(startDate: NSDate!, endDate: NSDate!, category: Int, userID: Int) {
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.isDefaultSet = false
        self.userID = userID
    }
}