//
//  StartScreen.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-19.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class StartScreen {
    
    class func getStartScreenID() -> String {
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("completedOnboarding") {
            return "InitialTabBarController"
        } else {
            return "RegisterViewController"
        }
    }
    
    class func completedOnboarding() {
        println("Completed onboarding - registering new startup screen")
        dispatch_async(dispatch_get_main_queue(), {
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "completedOnboarding")
        })
    }
}