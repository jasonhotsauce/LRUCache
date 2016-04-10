//
//  LRUCacheTests.swift
//  LRUCacheTests
//
//  Created by Wenbin Zhang on 4/9/16.
//  Copyright © 2016 Wenbin Zhang. All rights reserved.
//

import XCTest
@testable import LRUCache

class LRUCacheObject: NSObject, Sizable {
    var totalBytes: Double {
        return 1024 * 1024
    }
}

class LRUCacheTests: XCTestCase {

    var cache = LRUCache<String, LRUCacheObject>(maxCapacity: 5 * 1024 * 1024, preferedMemory: 2 * 1024 * 1024)

    func testInsert() {
        cache["test1"] = LRUCacheObject()
        XCTAssertNotNil(cache["test1"])
        XCTAssertEqual(cache.currentMemory, 1024 * 1024)
    }

    func testGetLatestUsedObject() {
        let obj1 = LRUCacheObject()
        let obj2 = LRUCacheObject()
        cache["test1"] = obj1
        cache["test2"] = obj2
        XCTAssertEqual(cache.latestUsedObject, obj2)
        XCTAssertEqual(cache.oldest, obj1)
    }

    func testRemoveObjectUntilPreferedMemory() {
        cache["test1"] = LRUCacheObject()
        cache["test2"] = LRUCacheObject()
        cache["test3"] = LRUCacheObject()
        cache["test4"] = LRUCacheObject()
        cache["test5"] = LRUCacheObject()
        cache["test6"] = LRUCacheObject()
        XCTAssertEqual(cache.currentMemory, 2 * 1024 * 1024)
        XCTAssertNil(cache["test1"])
        XCTAssertNil(cache["test2"])
        XCTAssertNil(cache["test3"])
        XCTAssertNil(cache["test4"])
        XCTAssertNotNil(cache["test5"])
        XCTAssertNotNil(cache["test6"])
    }

    func testItReOrdersCacheObjectsBasedOnUsage() {
        cache["test1"] = LRUCacheObject()
        cache["test2"] = LRUCacheObject()
        cache["test3"] = LRUCacheObject()
        cache["test4"] = LRUCacheObject()
        cache["test5"] = LRUCacheObject()
        let obj = cache["test3"]
        XCTAssertEqual(cache.latestUsedObject, obj)
        cache["test6"] = LRUCacheObject()
        XCTAssertNotNil(cache["test3"])
    }
    
}
