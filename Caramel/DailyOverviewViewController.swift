//
//  DailyOverviewViewController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-12.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class DailyOverviewViewController: UIViewController {
    
    @IBOutlet weak var trendGraphView: TrendGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("Updating trend graph")
        let data = self.prepareTrendData(NSDate())
        
        Rotation.rotateLandscape()
        
        self.trendGraphView.setCurrentData(data.0, maxYValue: 100)
        self.trendGraphView.setPreviousData(data.1, maxYValue: 100)
        
        /*self.trendGraphView.setCurrentData([69, 21, 0, 0, 34, 45, 5, 13, 13, 1, 5], maxYValue: 100) //display testing
        self.trendGraphView.setPreviousData([19, 23, 31, 44, 59, 5, 25, 10, 23, 45, 6], maxYValue: 100)
        var arr = [Int]()
        for i in 1...100 {
            arr.append(i)
        }
        self.trendGraphView.setCurrentData(arr, maxYValue: 100) //display testing
        self.trendGraphView.setPreviousData([], maxYValue: 100)*/
        self.trendGraphView.setNeedsDisplay()
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
}
