//
//  ProtocolsViewController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-11.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ProtocolsViewController: UIViewController {
    @IBOutlet weak var frustrationButton: UIButton!
    @IBOutlet weak var conflictButton: UIButton!
    @IBOutlet weak var overwhelmedButton: UIButton!
    @IBOutlet weak var fearButton: UIButton!
    
    var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttons = [self.frustrationButton, self.conflictButton, self.overwhelmedButton, self.fearButton]
        
        for index in 0 ..< self.buttons.count {
            self.buttons[index].layer.borderColor = UIColor.blackColor().CGColor
            self.buttons[index].layer.borderWidth = 0.5
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}