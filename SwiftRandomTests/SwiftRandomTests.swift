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
        let result = randCont(1.0, 1.0)
        
        XCTAssertEqual(1.0, result)
    }

    
    func testNormal() {
        let result = randNormals(mean: 0, 1, 11)
        print(result)
    }
    
}
    