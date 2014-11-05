//
//  HTTPRequest.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

let ROOT_URL = "http://23.239.1.132"
let API_VERSION = "/api/v1.0"

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
    
    class func sendUserAuthRequest(
        user: UserRecord,
        responseCallback: (NSHTTPURLResponse!, Agent.Data!, NSError!) -> Void
    ) {
        println("Sending user auth request")
        let req = Agent.put(ROOT_URL + API_VERSION + "/user")
        var json = [String: AnyObject]()
        json["FirstName"] = user.firstName
        if user.lastName != nil {
            json["LastName"] = user.lastName
        } else {
            json["LastName"] = NSNull()
        }
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