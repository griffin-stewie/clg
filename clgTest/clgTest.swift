//
//  clgTest.swift
//  clgTest
//
//  Created by griffin-stewie on 2015/05/27.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa
import XCTest

class clgTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConvertToSnakeCase1() {
        // This is an example of a functional test case.
        let input = "cell background"
        let output = input.snakeCase()
        XCTAssertEqual(output, "cell_background", "should be equal")
    }

    func testConvertToSnakeCase2() {
        // This is an example of a functional test case.
        let input = "cell_background"
        let output = input.snakeCase()
        XCTAssertEqual(output, "cell_background", "should be equal")
    }

    func testConvertToSnakeCase3() {
        // This is an example of a functional test case.
        let input = "cellBackground"
        let output = input.snakeCase()
        XCTAssertEqual(output, "cell_background", "should be equal")
    }


    func testConvertToCamelCase1() {
        // This is an example of a functional test case.
        let input = "cellBackground"
        let output = input.camelCase()
        XCTAssertEqual(output, "cellBackground", "should be equal")
    }

    func testConvertToCamelCase2() {
        // This is an example of a functional test case.
        let input = "cell background"
        let output = input.camelCase()
        XCTAssertEqual(output, "cellBackground", "should be equal")
    }

    func testConvertToCamelCase3() {
        // This is an example of a functional test case.
        let input = "cell_background"
        let output = input.camelCase()
        XCTAssertEqual(output, "cellBackground", "should be equal")
    }

    func testConvertToCamelCase4() {
        // This is an example of a functional test case.
        let input = "Cell Background"
        let output = input.camelCase()
        XCTAssertEqual(output, "cellBackground", "should be equal")
    }

}
