//
//  HTTPRequest.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

let ROOT_URL = "http://api.getbeyond.me"
let API_VERSION = "/v1.0"

class HTTPRequest {

    class func sendHRRequest(
        hrSamples: [HRSample]!,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
        println("Sending HR Request")
        let req = Agent.put(ROOT_URL + API_VERSION + "/heart")
        var json = HTTPRequest.getDefaultJSON()
        
        var samplesJSON = [[String: AnyObject]]()
        for sample in hrSamples {
            samplesJSON.append(sample.asJSON())
        }
        json["Samples"] = samplesJSON
        
        if let lastLocation = Location.getLastLocation() {
            json["Location"] = lastLocation
        } else {
            json["Location"] = NSNull()
        }
        
        req.send(json)
        req.end(responseCallback)
    }
    
    class func sendStressRequest(
        stressInterval: StressScoreInterval!,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
        println("Sending Stress Score Request")
        let req = Agent.post(ROOT_URL + API_VERSION + "/score")
        var json = HTTPRequest.getDefaultJSON()
        
        json["StartTime"] = Conversion.dateToString(stressInterval.startDate)
        json["EndTime"] = Conversion.dateToString(stressInterval.endDate)
        
        req.send(json)
        req.end(responseCallback)
    }
    
    class func sendBulkStressRequest(
        startDate: NSDate!,
        endDate: NSDate!,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
        println("Sending Bulk Stress Score Request")
        let req = Agent.post(ROOT_URL + API_VERSION + "/score/bulk")
        var json = HTTPRequest.getDefaultJSON()
        
        json["StartTime"] = Conversion.dateToString(startDate)
        json["EndTime"] = Conversion.dateToString(endDate)
        
        req.send(json)
        req.end(responseCallback)
    }
    
    class func sendTrainingIntervalRequest(
        trainingInterval: TrainingInterval!,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
        println("Sending Training Interval Request")
        let req = Agent.put(ROOT_URL + API_VERSION + "/training")
        var json = HTTPRequest.getDefaultJSON()
        
        json["StartTime"] = Conversion.dateToString(trainingInterval.startDate)
        json["EndTime"] = Conversion.dateToString(trainingInterval.endDate)
        json["Category"] = trainingInterval.category
        json["IsDefaultSet"] = trainingInterval.isDefaultSet
        
        req.send(json)
        req.end(responseCallback)
    }
    
    class func sendUserAddRequest(
        user: UserRecord,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
        println("Sending user adding request")
        let req = Agent.put(ROOT_URL + API_VERSION + "/user/add")
        var json = [String: AnyObject]()
        json["UserName"] = user.userName
        json["Password"] = user.password
        req.send(json)
        req.end(responseCallback)
    }
    
    class func sendUserVerifyRequest(
        user: UserRecord,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
            println("Sending user verification request")
            let req = Agent.post(ROOT_URL + API_VERSION + "/user/verify")
            var json = [String: AnyObject]()
            json["UserName"] = user.userName
            json["Password"] = user.password
            req.send(json)
            req.end(responseCallback)
    }
    
    class func sendUserCalibrationCountRequest(
        user: UserRecord,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
            println("Sending user calibration count request")
            let req = Agent.post(ROOT_URL + API_VERSION + "/user/calibrate")
            var json = [String: AnyObject]()
            json["ID"] = user.userID
            json["Password"] = user.password
            req.send(json)
            req.end(responseCallback)
    }
    
    private class func getDefaultJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        json["ID"] = User.getUserID()
        json["Password"] = User.getPassword()
        return json
    }
}