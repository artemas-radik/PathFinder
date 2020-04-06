//
//  Queue.swift
//  PathFinder
//
//  Created by AJ Radik on 4/6/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation

class Queue<T> {
    
    class Node<T> {
        let data: T?
        var left: Node<T>?
        var right: Node<T>?
        
        init(data: T?, left: Node<T>?, right: Node<T>?) {
            self.data = data
            self.left = left
            self.right = right
        }
    }
    
    var size: Int
    let head: Node<T>
    let tail: Node<T>
    
    init() {
        size = 0
        head = Node<T>(data: nil, left: nil, right: nil)
        tail = Node<T>(data: nil, left: head, right: nil)
        head.right = tail
    }
    
    func enQueue(item: T) {
        let previous = tail.left
        let newNode = Node(data: item, left: previous, right: tail)
        tail.left = newNode
        previous!.right = newNode
        size+=1
    }
    
    func deQueue() -> T{
        let toExtractDataFrom = head.right
        head.right = head.right!.right!
        head.right!.left! = head
        size-=1
        return toExtractDataFrom!.data!
    }
    
}
