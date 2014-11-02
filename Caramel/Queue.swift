//
//  Queue.swift
//  Caramel
//
//  Created by Shine Wang on 2014-10-28.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

class Node<T> {
    
    var value: T? = nil
    var next: Node<T>? = nil
}

class Queue<T> {
    
    private var front: Node<T>?
    private var back: Node<T>?
    private var size: Int
    
    init() {
        self.front = nil
        self.back = nil
        self.size = 0
    }
    
    func push(value: T?) {
        self.size++
        if self.back == nil {
            self.back = Node<T>()
            self.back!.value = value
            self.back!.next = nil
        } else {
            var newNode = Node<T>()
            newNode.value = value
            self.back!.next = newNode
            self.back = newNode
        }
        if self.size == 1 {
            self.front = self.back
        }
    }
    
    func pop() -> T? {
        if self.size == 0 {
            return nil
        }
        self.size--
        var retValue = self.front!.value
        self.front = self.front!.next
        if self.size == 0 {
            self.back = nil
        }
        return retValue
    }
    
    func length() -> Int {
        return self.size
    }
    
    func asArray() -> [T] {
        var result = [T]()
        var point = self.front
        while point != nil {
            result.append(point!.value!)
            point = point!.next
        }
        return result
    }
}