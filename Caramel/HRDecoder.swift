//
//  HRDecoder.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

//bitwise masks
let HRFormatUINT16Mask: UInt8 = 0x01 << 0
let HRSensorInContactMask: UInt8 = 0x01 << 1
let HRSensorContactSupportedMask: UInt8 = 0x01 << 2
let HREnergyExpendedMask: UInt8 = 0x01 << 3
let HRRRIntervalPresentMask: UInt8 = 0x01 << 4

class HRDecoder {
    
    class func dataToHRSample(value: NSData!) -> HRSample? {
        /*
        https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.heart_rate_measurement.xml
        Flags for heart rate characteristic
        Heart rate format (bit 0)
        0 == UINT8
        1 == UINT16
        
        Sensor contact status (bits 1-2)
        0 == feature not supported
        1 == feature not supported
        2 == feature supported no contact
        3 == feature supported contact
        
        Energy expended status (bit 3)
        0 == not present
        1 == present
        
        RR-Interval values (bit 4)
        0 == not present
        1 == present
        
        Reserved (bits 5-7)
        
        Decode the value (flags and heart rate)
        Example with 16 bit heart rate, energy expended, and zero or more RR-Interval values
        +--------+--------+--------+--------+--------+--------+--------+--------+--------
        | flags  | HR 16           | Energy Expended | RR-Interval 0   | RR-Interval 1 ...
        +--------+--------+--------+--------+--------+--------+--------+--------+--------
        
        Example with 8 bit heart rate and zero or more RR-Interval values
        +--------+--------+--------+--------+--------+--------
        | flags  | HR 8   | RR-Interval 0   | RR-Interval 1 ...
        +--------+--------+--------+--------+--------+--------
        */
        // the number of elements:
        
        let currentDate = NSDate()

        let count = value.length / sizeof(UInt8)
        println("number of bytes: \(count)")
        
        // create array of appropriate length:
        var array = [UInt8](count: count, repeatedValue: 0)
        
        // copy bytes into array
        value.getBytes(&array, length:count * sizeof(UInt8))
        
        var curIndex = 0
        
        let flags = array[curIndex]
        curIndex += 1
        
        let contactFeatureSupported = (flags & HRSensorContactSupportedMask) == HRSensorContactSupportedMask
        let inContact = contactFeatureSupported && ((flags & HRSensorInContactMask) == HRSensorInContactMask)
        let rrIntervalPresent = (flags & HRRRIntervalPresentMask) == HRRRIntervalPresentMask
        let energyExpendedPresent = (flags & HREnergyExpendedMask) == HREnergyExpendedMask
        
        println("contact supported \(contactFeatureSupported), incontact \(inContact), rrIntervalPresent \(rrIntervalPresent), energyExpendedPresent \(energyExpendedPresent)")
        
        if !inContact || count < 2 {
            return nil
        }
        
        // Check heart rate format
        var heartRate: Int
        
        if ((flags & HRFormatUINT16Mask) == HRFormatUINT16Mask) {
            heartRate = Int(UInt16(array[curIndex]) | (UInt16(array[curIndex+1]) << 8))
            curIndex += 2
        } else {
            heartRate = Int(array[curIndex])
            curIndex += 1
        }
        println("heart rate: \(heartRate)")
        
        // TODO: move past energy expended field
        if energyExpendedPresent {
            curIndex += 2
        }
        if !rrIntervalPresent {
            return HRSample(date: currentDate, device: "Wahoo TICKR", hr: heartRate, hrv: nil)
        }
        
        var rrIntervals = [Int]()
        for ; curIndex + 1 < count; curIndex += 2 {
            let rrInterval: UInt16 = UInt16(array[curIndex]) | (UInt16(array[curIndex+1]) << 8)
            rrIntervals.append(Int(rrInterval))
        }
        println("RR intervals: \(rrIntervals)")
        println("array: \(array)")
        return HRSample(date: currentDate, device: "Wahoo TICKR", hr: heartRate, hrv: rrIntervals)
    }
}