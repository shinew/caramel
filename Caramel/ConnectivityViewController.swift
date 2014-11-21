//
//  ConnectivityViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-21.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ConnectivityViewController: UIViewController {
    
    @IBOutlet weak var currentHRLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var bluetoothConnectivity = BluetoothConnectivity()
    
    @IBAction func connectButtonDidPress(sender: AnyObject) {
        println("Restart Bluetooth background task")
        AppDelegate.restartBGTask()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bluetoothConnectivity.setCallbacks({(Void) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
            })}, disconnectedCallback: {(Void) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.currentHRLabel.text = "Disconnected"
                    self.currentHRLabel.font = UIFont(name: "Univers Light Condensed", size: 18)
                })}
        )
        self.bluetoothConnectivity.setLongRunningTimer()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
