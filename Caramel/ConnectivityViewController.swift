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
        
        self.bluetoothConnectivity.setCallbacks(
            nil,
            disconnectedCallback: {(Void) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if self.currentHRLabel != nil {
                        self.currentHRLabel.text = "Disconnected"
                        self.currentHRLabel.font = UIFont(name: "Univers Light Condensed", size: 18)
                    }
                })}
        )
        
        HRBluetooth.setHRUpdateCallback(self.newHeartRateCallback)
        self.bluetoothConnectivity.setLongRunningTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newHeartRateCallback(data: NSData!) -> Void {
        println("(ConnectivityOnboarding) Received new heart rate data")
        var hrSample = HRDecoder.dataToHRSample(data)
        if hrSample != nil && hrSample!.hr != nil && hrSample!.hr < 150 {
            self.currentHRLabel.font = UIFont(name: "Univers Light Condensed", size: 50)
            Timer.setLastHRBluetoothReceivedDate(NSDate())
            self.currentHRLabel.text = "\(hrSample!.hr!)"
        }
    }
}
