//
//  PortraitViewController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-24.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class PortraitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Rotation.rotatePortrait()
    }
}
