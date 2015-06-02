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
        let result = randomContinuousUniform(min: 1.0, max: 1.0)
        
        XCTAssert(result == nil)
    }
    
    func testUniformMaxSmallerThanMin() {
        let result = randomContinuousUniform(min: 1, max: 0)
        
        XCTAssert(result == nil)
    }
    
    func testUniformArray() {
        let result = randomContinuousUniformArray(min: 0, max: 1, sampleLength: 0)
        
        XCTAssert(result == nil)
    }
    
    
}
    