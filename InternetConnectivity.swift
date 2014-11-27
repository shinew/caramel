//
//  InternetConnectivity.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-26.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

var _internetConnected = true

class InternetConnectivity {
    
    class func getInternetConnected() -> Bool {
        return _internetConnected
    }
    
    class func setInternetConnected(internet: Bool) {
        _internetConnected = internet
    }
}