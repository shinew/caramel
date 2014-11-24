//
//  BreaksViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class BreaksViewController: PortraitViewController {

    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var coffeeLabel: UILabel!
    @IBOutlet weak var talkingLabel: UILabel!
    @IBOutlet weak var nappingLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var snackLabel: UILabel!
    
    
    @IBOutlet weak var walkingButton: UIButton!
    @IBOutlet weak var coffeeButton: UIButton!
    @IBOutlet weak var talkingButton: UIButton!
    @IBOutlet weak var nappingButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var snackButton: UIButton!
    
    var buttonCounters = [String: BreakActivityCounter]()
    let activities = ["Walking", "Coffee", "Talking", "Napping", "Music", "Snack"]
    var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttons = [self.walkingButton, self.coffeeButton, self.talkingButton, self.nappingButton, self.musicButton, self.snackButton]
        
        for index in 0 ..< self.buttons.count {
            self.buttons[index].layer.borderColor = UIColor.blackColor().CGColor
            self.buttons[index].layer.borderWidth = 0.5
        }
        
        for activity in self.activities {
            var activityCounter = BreakActivityCounter(activity: activity, counter: 0, userID: User.getUserID())
            self.buttonCounters[activity] = Database.getBreakActivityCounter(activityCounter)
        }
        self.refreshActivityCounters()
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
    @IBAction func nappingButtonDidPress(sender: AnyObject) {
        self.incrementActivity("Napping")
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
                    self.walkingLabel.text = String(self.buttonCounters[activity]!.counter)
                case "Coffee":
                    self.coffeeLabel.text = String(self.buttonCounters[activity]!.counter)
                case "Talking":
                    self.talkingLabel.text = String(self.buttonCounters[activity]!.counter)
                case "Napping":
                    self.nappingLabel.text = String(self.buttonCounters[activity]!.counter)
                case "Music":
                    self.musicLabel.text = String(self.buttonCounters[activity]!.counter)
                case "Snack":
                    self.snackLabel.text = String(self.buttonCounters[activity]!.counter)
                default:
                    println("Couldn't find activity \(activity)")
                }
            }
        })
    }
}
