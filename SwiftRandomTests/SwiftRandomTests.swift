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
        let result = randContUniform(1.0, 1.0)
        
        XCTAssert(result == 1)
    }
    
    
    func testUniformArray() {
        let result = randContUniforms(0, 1, 0)
        
        XCTAssert(result.isEmpty)
    }
    
    
}
    