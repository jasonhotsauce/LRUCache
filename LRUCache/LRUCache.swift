//
//  LRUCache.swift
//  LRUCache
//
//  Created by Wenbin Zhang on 4/9/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import Foundation

public protocol Sizable: class {
    var totalBytes: Double {get}
}

private final class DoubleLinkedList<K: Hashable, E: Sizable> : NSObject {
    var next : DoubleLinkedList<K, E>?
    weak var parent: DoubleLinkedList<K, E>?
    var obj : E
    var identifier: K

    init(object: E, identifier: K) {
        obj = object
        self.identifier = identifier
    }
}

public class LRUCache<K: Hashable, E: Sizable> {
    private(set) var maxCapacity: Double
    private(set) var preferedMemory: Double
    private(set) var currentMemory: Double

    var latestUsedObject: E? {
        return head?.obj
    }

    var oldest : E? {
        return tail?.obj
    }

    private var head: DoubleLinkedList<K, E>?
    private var tail: DoubleLinkedList<K, E>?
    private var internalStorage: [K: DoubleLinkedList<K, E>]

    init(maxCapacity: Double, preferedMemory: Double) {
        self.maxCapacity = maxCapacity
        self.preferedMemory = preferedMemory
        self.currentMemory = 0.0
        internalStorage = [K:DoubleLinkedList<K, E>]()
    }

    public subscript(key: K) -> E? {
        get {
            guard let node = internalStorage[key] else {
                return nil
            }
            remove(node)
            addToHead(node)
            return node.obj
        }

        set {
            guard let object = newValue else {
                return
            }
            if let cachedNode = internalStorage[key] {
                cachedNode.obj = object
                remove(cachedNode);
                currentMemory -= object.totalBytes
                addToHead(cachedNode)
            } else {
                let node = DoubleLinkedList<K, E>(object: object, identifier: key)
                internalStorage[key] = node
                addToHead(node)
            }
            currentMemory += object.totalBytes
            if (currentMemory > maxCapacity) {
                while(currentMemory > preferedMemory) {
                    guard let nodeToRemove = tail else {
                        return
                    }
                    remove(nodeToRemove)
                    internalStorage.removeValueForKey(nodeToRemove.identifier)
                    currentMemory -= nodeToRemove.obj.totalBytes
                }
            }
        }
    }

    private func remove(node: DoubleLinkedList<K, E>) {
        if node == head {
            node.next?.parent = nil
            head = node.next
        } else if node == tail {
            node.parent?.next = nil
            tail = node.parent
        } else {
            node.parent?.next = node.next
            node.next?.parent = node.parent
        }
    }

    private func addToHead(node: DoubleLinkedList<K, E>) {
        node.parent = nil
        node.next = head
        head?.parent = node
        head = node
        guard let _ = tail else {
            tail = node
            return
        }
    }
}