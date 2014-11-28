//
//  BackgroundSuspension.swift
//  GetBeyond
//
//  Created by Shine Wang on 2014-11-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _memoryWarningSent = true

class BackgroundSuspension {
    
    class func getMemoryWarningSent() -> Bool {
        return _memoryWarningSent
    }
    
    class func setMemoryWarningSent(warning: Bool) {
        _memoryWarningSent = warning
    }
}