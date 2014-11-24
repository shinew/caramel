//
//  ActionsViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ActionsViewController: PortraitViewController {

    @IBOutlet weak var breathButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    var buttons = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.breakButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.breakButton.layer.borderWidth = 0.3
    }
}
