//
//  Database.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import CoreData

private let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

class Database {
    // the connection to the DB
    
    class func addStressScoreInterval(interval: StressScoreInterval!) {
        println("(DB) Adding a stress score interval")
        var stressScore = NSEntityDescription.insertNewObjectForEntityForName("StressScoreInterval", inManagedObjectContext: appContext) as NSManagedObject
        stressScore.setValue(interval.score, forKey: "score")
        stressScore.setValue(interval.startDate, forKey: "startDate")
        stressScore.setValue(interval.endDate, forKey: "endDate")
        stressScore.setValue(interval.userID, forKey: "userID")
        appContext.save(nil)
        println("(DB) \(stressScore)")
        println("(DB) StressScoreInterval saved.")
    }
    
    class func getSortedStressIntervals(startDate: NSDate!, endDate: NSDate!) -> [StressScoreInterval] {
        println("(DB) Retriving stress score intervals")
        var request = NSFetchRequest(entityName: "StressScoreInterval")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND (userID == %i)", startDate, endDate, User.getUserID())
        var searchResults = appContext.executeFetchRequest(request, error: nil)!
        var unsortedIntervals = [StressScoreInterval]()
        for item in searchResults {
            let thisItem = item as NSManagedObject
            unsortedIntervals.append(StressScoreInterval(
                score: thisItem.valueForKey("score") as Int,
                startDate: thisItem.valueForKey("startDate") as NSDate,
                endDate: thisItem.valueForKey("endDate") as NSDate,
                userID: thisItem.valueForKey("userID") as Int
            ))
        }
        var sortedStressIntervals = sorted(
            unsortedIntervals,
            { s1, s2 in s1.startDate.compare(s2.startDate) == NSComparisonResult.OrderedAscending }
        )
        return sortedStressIntervals
    }

    class func addNotificationRecord(notif: NotificationRecord!) {
        println("(DB) Adding a notification record")
        var notifRecord = NSEntityDescription.insertNewObjectForEntityForName("NotificationRecord", inManagedObjectContext: appContext) as NSManagedObject
        notifRecord.setValue(notif.type, forKey: "type")
        notifRecord.setValue(notif.date, forKey: "date")
        notifRecord.setValue(notif.userID, forKey: "userID")
        appContext.save(nil)
        println("(DB) \(notifRecord)")
        println("(DB) notification record saved.")
    }

    class func getSortedNotificationRecords(startDate: NSDate!, endDate: NSDate!) -> [NotificationRecord] {
        println("(DB) Retriving notification records")
        var request = NSFetchRequest(entityName: "NotificationRecord")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (userID == %i)", startDate, endDate, User.getUserID())
        var searchResults = appContext.executeFetchRequest(request, error: nil)!
        var unsortedRecords = [NotificationRecord]()
        for item in searchResults {
            let thisItem = item as NSManagedObject
            unsortedRecords.append(NotificationRecord(
                type: thisItem.valueForKey("type") as String,
                date: thisItem.valueForKey("date") as NSDate,
                userID: thisItem.valueForKey("userID") as Int
            ))
        }
        var sortedRecords = sorted(
            unsortedRecords,
            { s1, s2 in s1.date.compare(s2.date) == NSComparisonResult.OrderedAscending }
        )
        return sortedRecords
    }
    
    class func updateBreakActivityCounter(activity: BreakActivityCounter) {
        println("(DB) Updating break activity counter")
        var request = NSFetchRequest(entityName: "BreakActivityCounter")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(activity == %@) AND (userID == %i)", activity.activity, activity.userID)
        var searchResults = appContext.executeFetchRequest(request, error: nil)!
        if searchResults.count == 0 {
            var stressScore = NSEntityDescription.insertNewObjectForEntityForName("BreakActivityCounter", inManagedObjectContext: appContext) as NSManagedObject
            stressScore.setValue(activity.activity, forKey: "activity")
            stressScore.setValue(activity.counter, forKey: "counter")
            stressScore.setValue(activity.userID, forKey: "userID")
        } else {
            let item = searchResults.first! as NSManagedObject
            item.setValue(activity.counter, forKey: "counter")
            appContext.save(nil)
        }
    }
    
    class func getBreakActivityCounter(fixedActivity: BreakActivityCounter) -> BreakActivityCounter {
        var activity = fixedActivity
        println("(DB) Retriving break activity counter")
        var request = NSFetchRequest(entityName: "BreakActivityCounter")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(activity == %@) AND (userID == %i)", activity.activity, activity.userID)
                var searchResults = appContext.executeFetchRequest(request, error: nil)!
        if searchResults.count == 0 {
            activity.counter = 0
        } else {
            let item = searchResults.first! as NSManagedObject
            activity.counter = item.valueForKey("counter") as Int
        }
        return activity
    }
}