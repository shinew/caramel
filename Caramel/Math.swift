//
//  Math.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-03.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class Math {
    class func stddev(numbers: [Int]) -> Double {
        var sum = 0.0
        var avg = Math.mean(numbers)
        for num in numbers {
            sum += (Double(num) - avg) * (Double(num) - avg)
        }
        sum /= Double(numbers.count)
        return sqrt(sum)
    }
    
    class func mean(numbers: [Int]) -> Double {
        var sum = 0.0
        for num in numbers {
            sum += Double(num)
        }
        sum /= Double(numbers.count)
        return sum
    }
    
    class func rms(numbers: [Int]) -> Double {
        var sum = 0.0
        for num in numbers {
            sum += Double(num) * Double(num)
        }
        sum /= Double(numbers.count)
        return sqrt(sum)
    }
}