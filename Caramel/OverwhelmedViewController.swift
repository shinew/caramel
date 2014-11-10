//
//  OverwhelmedViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-09.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class OverwhelmedViewController: UIViewController {
    @IBOutlet weak var checkMarkImage1: UIImageView!
    @IBOutlet weak var checkMarkImage2: UIImageView!
    @IBOutlet weak var checkMarkImage3: UIImageView!
    @IBOutlet weak var checkMarkImage4: UIImageView!
    
    @IBOutlet weak var step1Button: UIButton!
    @IBOutlet weak var step2Button: UIButton!
    @IBOutlet weak var step3Button: UIButton!
    @IBOutlet weak var step4Button: UIButton!
    
    @IBOutlet weak var maskView: UIView!
    private var images: [UIImageView]!
    private var buttons: [UIButton]!
    private var index: Int!
    
    private var color = Conversion.UIColorFromRGB(43,green:62,blue:140)
    
    @IBAction func step1ButtonDidPress(sender: AnyObject) {
        self.index = ProtocolAnimation.animate(index, buttons: self.buttons, images: self.images, maskView: self.maskView, color: color)
    }
    
    @IBAction func step2ButtonDidPress(sender: AnyObject) {
        self.index = ProtocolAnimation.animate(index, buttons: self.buttons, images: self.images, maskView: self.maskView, color: color)
    }
    
    
    @IBAction func step3ButtonDidPress(sender: AnyObject) {
        self.index = ProtocolAnimation.animate(index, buttons: self.buttons, images: self.images, maskView: self.maskView, color: color)
    }
    
    @IBAction func step4ButtonDidPress(sender: AnyObject) {
        self.index = ProtocolAnimation.animate(index, buttons: self.buttons, images: self.images, maskView: self.maskView, color: color)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maskView.transform = CGAffineTransformMakeTranslation(0, 500)
        self.images = [self.checkMarkImage1, self.checkMarkImage2, self.checkMarkImage3, self.checkMarkImage4]
        self.buttons = [self.step1Button, self.step2Button, self.step3Button, self.step4Button]
        self.index = 0
    }
}
