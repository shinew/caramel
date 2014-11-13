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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.trendGraphView.setCurrentData([69, 21, 0, 0, 34, 45, 5], maxYValue: 100)
        self.trendGraphView.setNeedsDisplay()
    }
}
