//
//  HRSample.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct HRSample {
    
    var device: String
    var date: NSDate
    var movement: Bool
    var hr: Int?
    var hrv: [Int]?
    
    init(date: NSDate, device: String, hr: Int?, hrv: [Int]?) {
        self.device = device
        self.date = date
        self.movement = false //for now
        self.hr = hr
        self.hrv = hrv
    }
    
    func asJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        json["Device"] = self.device
        json["Time"] = Conversion.dateToString(self.date)
        json["Movement"] = self.movement
        
        if self.hr != nil {
            json["HR"] = self.hr
        } else {
            json["HRV"] = NSNull()
        }
        if self.hrv != nil {
            json["HRV"] = self.hrv
        } else {
            json["HRV"] = NSNull()
        }
        return json
    }
}