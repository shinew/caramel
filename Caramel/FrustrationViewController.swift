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
        checkMarkImage1.hidden = false
        step1Button.backgroundColor = UIColor.whiteColor()
        step1Button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        step2Button.backgroundColor = Conversion.UIColorFromRGB(31,green:150,blue:137)
        step2Button.setTitleColor(UIColor.whiteColor(),forState: UIControlState.Normal)
    }
    
    @IBAction func step2ButtonDidPress(sender: AnyObject) {
        checkMarkImage2.hidden = false
        step2Button.backgroundColor = UIColor.whiteColor()
        step2Button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        step3Button.backgroundColor = Conversion.UIColorFromRGB(31,green:150,blue:137)
        step3Button.setTitleColor(UIColor.whiteColor(),forState: UIControlState.Normal)
    }
    
    @IBAction func step3ButtonDidPress(sender: AnyObject) {
        checkMarkImage3.hidden = false
        step3Button.backgroundColor = UIColor.whiteColor()
        step3Button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        step4Button.backgroundColor = Conversion.UIColorFromRGB(31,green:150,blue:137)
        step4Button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
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
