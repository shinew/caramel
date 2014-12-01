//
//  DailyOverviewViewController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-12.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class DailyOverviewViewController: PortraitViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var trendGraphOverview: JBLineChartView!
    
    var times = ["1:00", "1:05", "1:10", "1:15", "1:20", "1:25", "1:30", "1:35", "1:40", "1:45", "1:50"]
    var currentDataValues = [69, 21, 0, 0, 34, 45, 5, 13, 13, 1, 5]
    var previousDataValues = [19, 23, 31, 44, 59, 5, 25, 10, 23, 45, 6]
    let currentColor = UIColor(red: 0.30, green: 0.55, blue: 0.76, alpha: 1.0)
    let previousColor = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1.0)
    
    @IBAction func refreshButtonDidPress(sender: AnyObject) {
        println("Restart Bluetooth background task")
        AppDelegate.restartBGTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        
        self.trendGraphOverview.dataSource = self
        self.trendGraphOverview.delegate = self
        
        //X-axis
        var footerView = JBLineChartFooterView(frame: CGRectMake(5.0, 5.0, 20.0, 20.0))
        footerView.sectionCount = 5
        self.trendGraphOverview.footerView = footerView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("Updating trend graph")
        let data = self.prepareTrendData(NSDate())
        
        //self.trendGraphView.setCurrentData(data.0, maxYValue: 100)
        //self.trendGraphView.setPreviousData(data.1, maxYValue: 100)
        
        /*self.currentDataValues = [69, 21, 0, 0, 34, 45, 5, 13, 13, 1, 5]
        self.previousDataValues = [19, 23, 31, 44, 59, 5, 25, 10, 23, 45, 6]
        for i in 1...100 {
            arr.append(i)
        }   
        self.trendGraphView.setCurrentData(arr, maxYValue: 100) //display testing
        self.trendGraphView.setPreviousData([], maxYValue: 100)*/

        self.trendGraphOverview.reloadData()
        self.trendGraphOverview.setNeedsDisplay()
    }
    
    private func prepareTrendData(date: NSDate) -> ([Int], [Int]) {
        let startDate = Conversion.dateToTimelessDate(date)
        let yesterdayStartDate = startDate.dateByAddingTimeInterval(-60 * 60 * 24)
        let todayData = self.organizeDailyData(startDate)
        let yesterdayData = self.organizeDailyData(yesterdayStartDate)
        return (todayData, yesterdayData)
    }
    
    private func organizeDailyData(startDate: NSDate) -> [Int] {
        let endDate = startDate.dateByAddingTimeInterval(60 * 60 * 24)
        let granularity = NSTimeInterval(Constants.getProfileTrendFineness() * 60) * 2
        let intervals = Database.getSortedStressIntervals(startDate, endDate: endDate)
        var movingDate = startDate
        var index = 0
        var result = [Int]()
        while movingDate.compare(endDate) == NSComparisonResult.OrderedAscending {
            //we take the maximum over that range as the display
            let movingEndDate = movingDate.dateByAddingTimeInterval(granularity)
            var maxScore: Int?
            //we want start <= scoreStartDate < end
            while index < intervals.count &&
                movingDate.compare(intervals[index].startDate) != NSComparisonResult.OrderedDescending &&
                movingEndDate.compare(intervals[index].startDate) == NSComparisonResult.OrderedDescending {
                    if maxScore == nil {
                        maxScore = intervals[index].score
                    } else {
                        maxScore = max(maxScore!, intervals[index].score)
                    }
                    index++
            }
            if maxScore == nil {
                maxScore = 0
            }
            result.append(maxScore!)
            movingDate = movingEndDate
        }
        return result
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGFloat) {
        let value = self.times[Int(horizontalIndex)]
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        // number of lines in chart
        // 1 = current, 0 = previous
        return 2
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        // number of values for a line
        if lineIndex == 1 {
            return UInt(self.currentDataValues.count)
        } else {
            return UInt(self.previousDataValues.count)
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        // y-position (y-axis) of point at horizontalIndex (x-axis)
        if lineIndex == 1 {
            return CGFloat(self.currentDataValues[Int(horizontalIndex)])
        } else {
            return CGFloat(self.previousDataValues[Int(horizontalIndex)])
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return CGFloat(1.0)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if lineIndex == 1 {
            return self.currentColor
        } else {
            return self.previousColor
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if lineIndex == 1 {
            return self.currentColor
        } else {
            return self.previousColor
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if lineIndex == 1 {
            return self.currentColor
        } else {
            return self.previousColor
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionFillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if lineIndex == 1 {
            return self.currentColor
        } else {
            return self.previousColor
        }
    }
}
