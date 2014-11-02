//
//  DashboardViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

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
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.hrBluetooth = HRBluetooth()
        self.movement = Movement()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        self.displayUpdateDateLabels()
        self.dashboardCallback = DashboardCallback(updatedScoreCallback)
        
        self.hrBluetooth.startScanningHRPeripheral(self.dashboardCallback.newHeartRateCallback)
        println("Loaded DashboardViewController view!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayUpdateDateLabels() {
        let dateFormatter = NSDateFormatter()
        let currentDate = NSDate()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        self.dayOfTheWeekLabel.text = dateFormatter.stringFromDate(currentDate).uppercaseString
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
        self.dateLabel.text = dateFormatter.stringFromDate(currentDate).uppercaseString
    }
    
    func updatedScoreCallback(interval: StressScoreInterval!) -> Void {
        println("Smooth score: \(interval.score)")
        self.todayOverallLabel.text = "\(interval.score)"
        Database.AddStressScoreInterval(interval)
    }
}
