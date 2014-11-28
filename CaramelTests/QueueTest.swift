//
//  QueueTest.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-29.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import GetBeyond
import XCTest

class QueueTests: XCTestCase {
    
    var testQueue: Queue<Int>!
    
    override func setUp() {
        super.setUp()
        self.testQueue = Queue<Int>()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasic() {
        XCTAssertEqual(0, self.testQueue.length())
        self.testQueue.push(123)
        XCTAssertEqual(1, self.testQueue.length())
        self.testQueue.push(44)
        XCTAssertEqual(2, self.testQueue.length())
        XCTAssertEqual(123, self.testQueue.pop()!)
        XCTAssertEqual(44, self.testQueue.pop()!)
    }
    
    func testNoItem() {
        XCTAssertNil(self.testQueue.pop())
        self.testQueue.push(123)
        self.testQueue.pop()
        XCTAssertNil(self.testQueue.pop())
    }
    
    func testExtensive() {
        self.testQueue.push(123)
        self.testQueue.push(44)
        XCTAssertEqual(123, self.testQueue.pop()!)
        self.testQueue.push(11)
        XCTAssertEqual(44, self.testQueue.pop()!)
        XCTAssertEqual(11, self.testQueue.pop()!)
        XCTAssertEqual(1, self.testQueue.length())
        XCTAssertNil(self.testQueue.pop())
        XCTAssertEqual(0, self.testQueue.length())
        self.testQueue.push(55)
        XCTAssertEqual(55, self.testQueue.pop()!)
    }
    
    func testArray() {
        let testArray = [1, 33, 4413, 34]
        for i in testArray {
            self.testQueue.push(i)
        }
    }
}