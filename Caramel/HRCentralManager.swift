//
//  HRCentralManager.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreBluetooth

class HRCentralManager: NSObject, CBCentralManagerDelegate {
    
    // constant Bluetooth UUIDs
    let HeartRateServiceUUID = CBUUID(string: "0x180D")
    let DeviceInformationUUID = CBUUID(string: "0x180A")
    
    var hrCBManager: CBCentralManager!
    var hrSensor: HRPeripheral!
    
    override init() {
        super.init()
    }
    
    func startCentralManager() {
        self.hrCBManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch central.state {
        case .PoweredOn:
            println("central \(central) powered on")
            /* Start scanning for peripherals offering the heart rate service. We'll
            pick up any peripheral in range that offers this service. */
            self.hrCBManager.scanForPeripheralsWithServices([self.HeartRateServiceUUID], options: nil)
        default:
            println("central \(central) state changed to: \(central.state.rawValue)")
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        println("discovered peripheral: \(peripheral)")
        println("advertisement data: \(advertisementData)")
        println("RSSI: \(RSSI)")
        
        /* Since we're going to try to connect the peripheral we need to hang on
        to a reference. In this simple example we're just connecting to
        one peripheral so we'll just accomodate one. We could use a collection.
        You can even use peripheral as a dictionary key. */
        self.hrSensor = HRPeripheral(peripheral: peripheral)
        
        // We've found one so let's stop scanning
        self.hrCBManager.stopScan()
        
        // Now we'll try to connect to the peripheral
        self.hrCBManager.connectPeripheral(self.hrSensor.peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        println("connected to \(peripheral)")
        
        // become the delegate for the peripheral
        peripheral.delegate = self.hrSensor
        
        /* Now we need to really gain access to the HR service and
        device information service so we will now discover those
        on this peripheral */
        peripheral.discoverServices([self.HeartRateServiceUUID, self.DeviceInformationUUID])
    }
}