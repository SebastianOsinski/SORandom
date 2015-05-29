//
//  SwiftRandomTests.swift
//  SwiftRandomTests
//
//  Created by Sebastian Osinski on 29.05.2015.
//  Copyright (c) 2015 Sebastian Osinski. All rights reserved.
//

import XCTest
import SwiftRandom

class SwiftRandomTests: XCTestCase {
    
    func testUniformEqualParameters() {
        let result = SwiftRandom.randomContinuousUniform(min: 1.0, max: 1.0)!
        
        XCTAssertEqual(1.0, result)
    }
    
    func testUniformMaxSmallerThanMin() {
        let result = SwiftRandom.randomContinuousUniform(min: 1, max: 0)
        
        XCTAssert(result == nil)
    }
    
    func testUniformArray() {
        let result = SwiftRandom.randomContinuousUniformArray(min: 0, max: 1, length: 0)
        
        XCTAssert(result == nil)
    }
    
    func testNormal() {
        let result = SwiftRandom.randomNormalArray(mean: 0, standardDeviation: 1, length: 11)
        print(result)
    }
    
}
