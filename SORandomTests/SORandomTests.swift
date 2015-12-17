//
//  SORandomTests.swift
//  SORandomTests
//
//  Created by Sebastian Osiński on 17.12.2015.
//  Copyright © 2015 Sebastian Osinski. All rights reserved.
//

import XCTest
import SORandom

class SORandomTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUniformEqualParameters() {
        let result = randContUniform(1.0, 1.0)
        
        XCTAssert(result == 1)
    }
    
    func testUniformArray() {
        let result = randContUniforms(0, 1, 0)
        
        XCTAssert(result.isEmpty)
    }
}
