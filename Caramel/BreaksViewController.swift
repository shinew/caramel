//
//  BreaksViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class BreaksViewController: UIViewController {

    @IBOutlet weak var napButton: UIButton!
    @IBOutlet weak var napLabel: UILabel!
    var napCounter = 6
    
    @IBAction func napButtonDidPress(sender: AnyObject) {
        self.napCounter++
        self.napLabel.text = String(self.napCounter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.napLabel.text = String(self.napCounter)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
