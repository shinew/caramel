//
//  DashboardViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    
    var hrBluetooth: HRBluetooth!
    var movement: Movement!
    var dashboardCallback: DashboardCallback!
    
    @IBOutlet weak var todayOverallLabel: UILabel!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastEventDurationLabel: UILabel!
    @IBOutlet weak var lastEventTimeLabel: UILabel!
    @IBOutlet weak var yesterdayScoreLabel: UILabel!
    @IBOutlet weak var percentageOfTodayStressedLabel: UILabel!
    
    @IBOutlet var profileCircleView: ProfileCircleView!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.hrBluetooth = HRBluetooth()
        self.movement = Movement()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.displayUpdateDateLabels()
        
        self.updateProfileCircle()
        self.dashboardCallback = DashboardCallback(updatedScoreCallback)
        
        self.hrBluetooth.startScanningHRPeripheral(self.dashboardCallback.newHeartRateCallback)
        println("Loaded DashboardViewController view")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayUpdateDateLabels() {
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        self.dayOfTheWeekLabel.text = dateFormatter.stringFromDate(currentDate)
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
        self.dateLabel.text = dateFormatter.stringFromDate(currentDate)
    }
    
    func updatedScoreCallback(interval: StressScoreInterval!) -> Void {
        println("Smooth score: \(interval.score)")
        self.todayOverallLabel.text = "\(interval.score)"
        Database.AddStressScoreInterval(interval)
        self.updateProfileCircle()
    }
    
    func updateProfileCircle() {
        println("Updating profile circle")
        let currentDate = NSDate()
        println("current time: \(currentDate)")
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: currentDate)
        var startDate = calendar.dateFromComponents(components)!
        var endDate = startDate.dateByAddingTimeInterval(60 * 60 * 24) //add 24hrs
        println("circle startDate: \(startDate)")
        println("circle endDate: \(endDate)")
        
        let stressIntervals = Database.GetStressScores(startDate, endDate: endDate)
        
        self.profileCircleView.setNeedsDisplay()
    }
}