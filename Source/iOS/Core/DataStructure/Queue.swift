//
//  Queue.swift
//  NTBSwift
//
//  Created by Kåre Morstøl on 11/07/14.
//
//  Using the "Two-Lock Concurrent Queue Algorithm" from http://www.cs.rochester.edu/research/synchronization/pseudocode/queues.html#tlq, without the locks.

// Ref: https://gist.github.com/kareman/931017634606b7f7b9c0

private class QueueItem<T> {
    let value: T!
    var next: QueueItem?
    
    init(_ value: T?) {
        self.value = value
    }
}

/***
 A standard queue (FIFO - First In First Out).
 Supports simultaneous adding and removing, but only one item can be added at a time,
 and only one item can be removed at a time.
*/
public class Queue<T> {
	public typealias Element = T
    
	private var front: QueueItem<Element>
	private var back: QueueItem<Element>
	
	public init () {
		// Insert dummy item. Will disappear when the first item is added.
		back = QueueItem(nil)
		front = back
	}
	
	/// Add a new item to the back of the queue.
	public func enqueue(value: Element) {
		back.next = QueueItem(value)
		back = back.next!
	}
	
	/// Return and remove the item at the front of the queue.
	public func dequeue() -> Element? {
		if let newhead = front.next {
			front = newhead
			return newhead.value
		} else {
			return nil
		}
	}
	
	public func isEmpty() -> Bool {
		return front === back
	}
}
