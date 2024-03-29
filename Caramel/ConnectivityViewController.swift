//
//  ConnectivityViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-21.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ConnectivityViewController: PortraitViewController {
    
    @IBOutlet weak var currentHRLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var bluetoothConnectivity = BluetoothConnectivity()
    var allowBTRestart = true
    var lastBluetoothResetTime: NSDate?
    
    @IBAction func connectButtonDidPress(sender: AnyObject) {
        if self.allowBTRestart {
            self.allowBTRestart = false
            println("Restart Bluetooth background task")
            AppDelegate.restartBGTask()
            NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("enableConnectButton"), userInfo: nil, repeats: false)
        }
    }
    
    @objc func enableConnectButton() {
        self.allowBTRestart = true
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
                })
                
                if self.lastBluetoothResetTime == nil || NSDate().timeIntervalSinceDate(self.lastBluetoothResetTime!) < Constants.getBluetoothReconnectInterval() {
                    return
                }
                self.lastBluetoothResetTime = NSDate()
                
                println("(BLConnect) Restarting HRBluetooth")
                
                HRAccumulator.startCountdown()
                HRAccumulator.restartCountdown()
                AppDelegate.restartBGTask()
            }
        )
        
        HRBluetooth.setHRUpdateCallback(self.newHeartRateCallback)
        self.bluetoothConnectivity.setLongRunningTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.bluetoothConnectivity.disableTimer()
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
