//
//  ActionsViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ActionsViewController: UIViewController {

    @IBOutlet weak var breathButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    var buttons = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        
        self.breakButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.breakButton.layer.borderWidth = 0.3

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
