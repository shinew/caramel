//
//  Rotation.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-23.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class Rotation {
    class func rotatePortrait() {
        HomeTabBarController.setCanRotate(false)
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    class func rotateLandscape() {
        HomeTabBarController.setCanRotate(true)
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
    }
}