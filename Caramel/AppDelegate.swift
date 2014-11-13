//
//  AppDelegate.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import HockeySDK

var _notificationType = NotificationType.Standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audioPlayer = AVAudioPlayer()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //HockeyApp integration
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("a645f2588d2e3fb133e495e35cf80250");
        BITHockeyManager.sharedHockeyManager().startManager();
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        
        //registering for sending user various kinds of notifications
        let types: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // Override point for customization after application launch.
        Movement.initalizeManager()
        
        self.playMusicInBackgroundToPreventSleep()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "BYND.Caramel" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Caramel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Caramel.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    class func setNotificationType(newType: NotificationType) {
        _notificationType = newType
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //Get the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let actionsTabIndex = 2
        
        let tabBarController = self.window!.rootViewController! as UITabBarController
        switch _notificationType {
        case .Original:
            //takes to previous page
            return
        case .Standard:
            //opens Dashboard page
            tabBarController.selectedIndex = 0
            var dashboardNavVC = tabBarController.viewControllers![0] as UINavigationController
            dashboardNavVC.popToRootViewControllerAnimated(false)
        case .LowStress:
            //opens Action page
            tabBarController.selectedIndex = actionsTabIndex
            var actionNavVC = tabBarController.viewControllers![actionsTabIndex] as UINavigationController
            actionNavVC.popToRootViewControllerAnimated(false)
        case .HighStress:
            //opens Actions -> Protocols page
            tabBarController.selectedIndex = actionsTabIndex
            var actionNavVC = tabBarController.viewControllers![actionsTabIndex] as UINavigationController
            actionNavVC.popToRootViewControllerAnimated(false)
            
            let protocolVC = storyboard.instantiateViewControllerWithIdentifier("ProtocolsViewController") as UIViewController
            actionNavVC.pushViewController(protocolVC, animated: false)
        }
    }
    
    func playMusicInBackgroundToPreventSleep() {
        var mp3Sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("notBlankSound", ofType: "mp3")!)
        println("Blank sound file: \(mp3Sound)")
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        self.audioPlayer = AVAudioPlayer(contentsOfURL: mp3Sound, error: &error)
        self.audioPlayer.numberOfLoops = -1
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
}
