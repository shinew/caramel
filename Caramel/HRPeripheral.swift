//
//  HRPeripheral.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation
import CoreBluetooth

class HRPeripheral : NSObject, CBPeripheralDelegate {
    
    // constant Bluetooth UUIDs
    let HeartRateServiceUUID = CBUUID(string: "0x180D")
    let DeviceInformationUUID = CBUUID(string: "0x180A")
    
    let HeartRateMeasurementCharacteristicUUID = CBUUID(string: "0x2A37")
    let BodySensorLocationCharacteristicUUID = CBUUID(string: "0x2A38")
    
    let ManufacturerNameCharacteristicUUID = CBUUID(string: "0x2A29")
    let ModelNumberCharacteristicUUID = CBUUID(string: "0x2A24")
    let HardwareRevisionCharacteristicUUID = CBUUID(string: "0x2A27")
    
    var peripheral: CBPeripheral
    
    init(peripheral: CBPeripheral!) {
        self.peripheral = peripheral
        super.init()
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        println("peripheral \(peripheral) discovered services \(peripheral.services)")
        
        // In particular we're looking for heart rate service and device informations
        for service in peripheral.services {
            /* We'll keep it simple for the demo but there are more sophisticated ways
            of working through the array if you're dealing with a more complicated
            scenario */
            switch service.UUID {
            case self.HeartRateServiceUUID:
                peripheral.discoverCharacteristics([self.HeartRateMeasurementCharacteristicUUID, self.BodySensorLocationCharacteristicUUID], forService: service as CBService)
            case self.DeviceInformationUUID:
                peripheral.discoverCharacteristics([self.ManufacturerNameCharacteristicUUID, self.ModelNumberCharacteristicUUID, self.HardwareRevisionCharacteristicUUID], forService: service as CBService)
            default:
                break
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        /* We want to read all of the characteristics except for
        the Heart Rate Measurement. The Heart Rate Measurement we
        want to subscribe to */
        for characteristic in service.characteristics {
            if characteristic.UUID == HeartRateMeasurementCharacteristicUUID {
                if characteristic.properties == CBCharacteristicProperties.Notify {
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
                } else {
                    println("HR sensor non-compliant with spec. HR measurement not NOTIFY")
                }
            } else {
                if (characteristic.properties == CBCharacteristicProperties.Read) {
                    peripheral.readValueForCharacteristic(characteristic as CBCharacteristic);
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("peripheral: \(peripheral)")
        println("updated characteristic: \(characteristic)")
        println("to value: \(characteristic.value)")
        if let callback = HRBluetooth.getHRUpdateCallback() {
            callback(characteristic.value)
        }
    }
}