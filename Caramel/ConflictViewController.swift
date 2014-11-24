//
//  ConflictViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-09.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ConflictViewController: PortraitViewController {
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
    private let finalIndex = 3
    
    private var color = Conversion.UIColorFromRGB(62,green:120,blue:179)
    
    @IBAction func step1ButtonDidPress(sender: AnyObject) {
        self.animateButton()
    }
    
    @IBAction func step2ButtonDidPress(sender: AnyObject) {
        self.animateButton()
    }
    
    @IBAction func step3ButtonDidPress(sender: AnyObject) {
        self.animateButton()
    }
    
    @IBAction func step4ButtonDidPress(sender: AnyObject) {
        self.animateButton()
    }
    
    func animateButton() {
        var isFinal = self.index == self.finalIndex
        self.index = ProtocolAnimation.animate(index, buttons: self.buttons, images: self.images, maskView: self.maskView, color: color, isFinal: isFinal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maskView.transform = CGAffineTransformMakeTranslation(0, 500)
        self.images = [self.checkMarkImage1, self.checkMarkImage2, self.checkMarkImage3, self.checkMarkImage4]
        self.buttons = [self.step1Button, self.step2Button, self.step3Button, self.step4Button]
        self.index = 0
    }
}
