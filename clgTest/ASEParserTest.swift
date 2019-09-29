//
//  ASEParserTest.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/21.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa
import XCTest

class ASEParserTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let path = Bundle(for: type(of: self)).path(forResource: "Material Palette", ofType: "ase")
        XCTAssertNotNil(path, "");
        let results = ASEParser().parse(path!)
        XCTAssertNotNil(results, "should not be nil")
        if let colorList = results {
            colorList.allKeys.forEach() { print($0) }
        }
    }

}
