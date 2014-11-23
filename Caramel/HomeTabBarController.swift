//
//  HomeTabBarController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-22.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

var _canRotate = false

class HomeTabBarController: UITabBarController {
    
    class func setCanRotate(canRotate: Bool) {
        _canRotate = canRotate
    }
    
    override func shouldAutorotate() -> Bool {
        let currentOrientation = UIDevice.currentDevice().valueForKey("orientation") as Int
        if currentOrientation == UIInterfaceOrientation.Portrait.rawValue {
            return !_canRotate
        }
        return _canRotate
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }

}