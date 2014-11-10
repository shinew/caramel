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
    
    private var images: [UIImageView]!
    private var buttons: [UIButton]!
    private var index: Int!
    
    @IBAction func step1ButtonDidPress(sender: AnyObject) {
        if self.index! == 0 {
            self.animate(self.index!)
            self.index!++
        }
    }
    
    @IBAction func step2ButtonDidPress(sender: AnyObject) {
        if self.index! == 1 {
            self.animate(self.index!)
            self.index!++
        }
    }
    
    @IBAction func step3ButtonDidPress(sender: AnyObject) {
        if self.index! == 2 {
            self.animate(self.index!)
            self.index!++
        }
    }
    
    @IBAction func step4ButtonDidPress(sender: AnyObject) {
        self.checkMarkImage4.hidden = false
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.images = [self.checkMarkImage1, self.checkMarkImage2, self.checkMarkImage3, self.checkMarkImage4]
        self.buttons = [self.step1Button, self.step2Button, self.step3Button, self.step4Button]
        self.index = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func animate(index: Int) {
        self.images[index].hidden = false
        self.buttons[index].backgroundColor = UIColor.whiteColor()
        self.buttons[index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.buttons[index + 1].backgroundColor = Conversion.UIColorFromRGB(31,green:150,blue:137)
        self.buttons[index + 1].setTitleColor(UIColor.whiteColor(),forState: UIControlState.Normal)
    }
}
