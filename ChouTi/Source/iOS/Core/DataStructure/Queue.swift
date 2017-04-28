//
//  Queue.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-14.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

// Ref: https://gist.github.com/kareman/931017634606b7f7b9c0

private class QueueItem<T> {
    let value: T
    var next: QueueItem?
    
    init(_ value: T) {
        self.value = value
    }
}

/***
 A standard queue (FIFO - First In First Out).
 Supports simultaneous adding and removing, but only one item can be added at a time,
 and only one item can be removed at a time.
 */
open class Queue<T> {
    public typealias Element = T
    
    fileprivate var head: QueueItem<Element>? {
        didSet {
			// When dequeued, from non-empty to empty
            if head == nil && tail != nil {
                tail = head
            }
        }
    }
    
    fileprivate var tail: QueueItem<Element>? {
        didSet {
			// When enqueued, from empty to non-empty
            if head == nil && tail != nil {
                head = tail
            }
        }
    }
    
    public init () {}
    
    /**
     Enqueue a new item at the end of the queue.
     
     - parameter value: new value
     */
    open func enqueue(_ value: Element) {
        let queueItem = QueueItem(value)
        tail?.next = queueItem
        tail = queueItem
    }
    
    /**
     Dequeue an item at the front of the queue.
     
     - returns: value dequeued.
     */
    open func dequeue() -> Element? {
        if let value = head?.value {
            head = head?.next
            return value
        }
        return nil
    }
    
    open func isEmpty() -> Bool {
        return head == nil
    }
}
