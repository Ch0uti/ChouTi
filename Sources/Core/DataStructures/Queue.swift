// Copyright © 2019 ChouTi. All rights reserved.

// Ref: https://gist.github.com/kareman/931017634606b7f7b9c0

/***
 A standard queue (FIFO - First In First Out).
 Supports simultaneous adding and removing, but only one item can be added at a time,
 and only one item can be removed at a time.
 */
public class Queue<Element> {
    private class Item<T> {
        let value: T
        var next: Item?

        init(_ value: T) {
            self.value = value
        }
    }

    private var head: Item<Element>? {
        didSet {
            // When dequeued, from non-empty to empty
            if head == nil, tail != nil {
                tail = head
            }
        }
    }

    private var tail: Item<Element>? {
        didSet {
            // When enqueued, from empty to non-empty
            if head == nil, tail != nil {
                head = tail
            }
        }
    }

    public init() {}

    /**
     Enqueue a new item at the end of the queue.

     - parameter value: new value
     */
    public func enqueue(_ value: Element) {
        let queueItem = Item(value)
        tail?.next = queueItem
        tail = queueItem
    }

    /**
     Dequeue an item at the front of the queue.

     - returns: value dequeued.
     */
    public func dequeue() -> Element? {
        if let value = head?.value {
            head = head?.next
            return value
        }
        return nil
    }

    public func isEmpty() -> Bool {
        return head == nil
    }
}
