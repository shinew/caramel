//
//  BreaksViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class BreaksViewController: UIViewController {
    
    @IBOutlet weak var walkingButton: UIButton!
    @IBOutlet weak var coffeeButton: UIButton!
    @IBOutlet weak var talkingButton: UIButton!
    @IBOutlet weak var napButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var snackButton: UIButton!
    
    
    var buttonCounters = [String: BreakActivityCounter]()
    let activities = ["Walking", "Coffee", "Talking", "Nap", "Music", "Snack"]

    override func viewDidLoad() {
        super.viewDidLoad()
        for activity in self.activities {
            var activityCounter = BreakActivityCounter(activity: activity, counter: 0, userID: User.getUserID())
            self.buttonCounters[activity] = Database.getBreakActivityCounter(activityCounter)
        }
        self.refreshActivityCounters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func walkingButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Walking")
    }
    @IBAction func coffeeButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Coffee")
    }
    @IBAction func talkingButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Talking")
    }
    @IBAction func napButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Nap")
    }
    @IBAction func musicButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Music")
    }
    @IBAction func snackButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Snack")
    }
    
    private func incrementActivity(activity: String) {
        self.buttonCounters[activity]!.counter++
        Database.updateBreakActivityCounter(self.buttonCounters[activity]!)
        self.refreshActivityCounters()
    }
    
    private func refreshActivityCounters() {
        dispatch_async(dispatch_get_main_queue(), {
            for activity in self.activities {
                switch activity {
                case "Walking":
                    self.walkingButton.titleLabel!.text = String(self.buttonCounters[activity]!.counter)
                case "Coffee":
                    self.coffeeButton.titleLabel!.text = String(self.buttonCounters[activity]!.counter)
                case "Talking":
                    self.talkingButton.titleLabel!.text = String(self.buttonCounters[activity]!.counter)
                case "Nap":
                    self.napButton.titleLabel!.text = String(self.buttonCounters[activity]!.counter)
                case "Music":
                    self.musicButton.titleLabel!.text = String(self.buttonCounters[activity]!.counter)
                case "Snack":
                    self.snackButton.titleLabel!.text = String(self.buttonCounters[activity]!.counter)
                default:
                    println("Couldn't find activity \(activity)")
                }
            }
        })
    }
}
