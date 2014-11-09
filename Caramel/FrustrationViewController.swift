//
//  FrustrationViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-09.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class FrustrationViewController: UIViewController {

    @IBOutlet weak var checkMarkImage1: UIImageView!
    @IBOutlet weak var checkMarkImage2: UIImageView!
    @IBOutlet weak var checkMarkImage3: UIImageView!
    @IBOutlet weak var checkMarkImage4: UIImageView!
    @IBOutlet weak var step1Button: UIButton!
    @IBOutlet weak var step2Button: UIButton!
    @IBOutlet weak var step3Button: UIButton!
    @IBOutlet weak var step4Button: UIButton!
    
    @IBAction func step1ButtonDidPress(sender: AnyObject) {
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

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
