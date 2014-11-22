//
//  HRQueue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _hrQueue = Queue<HRSample>()
var _newHRCallbacks = Dictionary<String, (HRSample!) -> Void>()

class HRQueue {
    
    class func length() -> Int {
        return _hrQueue.length()
    }
    
    class func addNewHRCallback(key: String, callback: (HRSample!) -> Void) {
        _newHRCallbacks[key] = callback
    }
    
    class func push(sample: HRSample) {
        println("Adding a new HR sample")
        _hrQueue.push(sample)
        
        for (key, callback) in _newHRCallbacks {
            callback(sample)
        }
    }
    
    class func popAll() -> [HRSample] {
        println("Popping all the HR data")
        var result = [HRSample]()
        var popped = _hrQueue.pop()
        while popped != nil {
            result.append(popped!)
            popped = _hrQueue.pop()
        }
        return result
    }
}