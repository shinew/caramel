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
    
    class func AddStressScoreInterval(interval: StressScoreInterval!) {
        println("Adding a stress score interval")
        var stressScore = NSEntityDescription.insertNewObjectForEntityForName("StressScoreInterval", inManagedObjectContext: appContext) as NSManagedObject
        stressScore.setValue(interval.score, forKey: "score")
        stressScore.setValue(interval.startDate, forKey: "startDate")
        stressScore.setValue(interval.endDate, forKey: "endDate")
        appContext.save(nil)
        println("\(stressScore)")
        println("StressScoreInterval saved.")
    }
    
    class func GetStressScores(startDate: NSDate!, endDate: NSDate!) -> [StressScoreInterval] {
        println("Retriving stress score intervals")
        var request = NSFetchRequest(entityName: "StressScoreInterval")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "(startDate >= %@) AND (endDate <= %@)", startDate, endDate)
        var searchResults = appContext.executeFetchRequest(request, error: nil)!
        var results = [StressScoreInterval]()
        for item in searchResults {
            let thisItem = item as NSManagedObject
            results.append(StressScoreInterval(
                score: thisItem.valueForKey("score") as Int,
                startDate: thisItem.valueForKey("startDate") as NSDate,
                endDate: thisItem.valueForKey("endDate") as NSDate
            ))
        }
        return results
    }
}