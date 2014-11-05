//
//  StressScoreInterval.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct StressScoreInterval {
    
    var score: Int
    var startDate: NSDate
    var endDate: NSDate
    var userID: Int
    
    init(score: Int!, startDate: NSDate!, endDate: NSDate!, userID: Int!) {
        self.score = score
        self.startDate = startDate
        self.endDate = endDate
        self.userID = userID
    }
}