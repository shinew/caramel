
//
//  Location.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-18.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import CoreLocation

var _lastLocation: String?

class Location: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    class func getLastLocation() -> String? {
        // see HTTPRequest -- attached with HR request for algorithm
        // used to help users identify the location of stress levels
        return _lastLocation
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        _lastLocation = "\(locations)"
    }
}