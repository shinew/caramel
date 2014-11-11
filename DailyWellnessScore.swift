//
//  DailyWellnessScore.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct DailyWellnessScore {
    
    var date: NSDate
    var score: Int
    var userID: Int
    
    init(date: NSDate!, score: Int!, userID: Int!) {
        self.score = score
        self.date = Conversion.dateToTimelessDate(date)
        self.userID = userID
    }
}