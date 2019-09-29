//
//  CSVParserTest.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/25.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import XCTest

class CSVParserTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {

        let path = Bundle(for: type(of: self)).path(forResource: "color", ofType: "csv")
        XCTAssertNotNil(path, "");

        if let path = path {
            let fileURL = URL(fileURLWithPath: path)
            let text = try! String(contentsOf:fileURL , encoding: String.Encoding.utf8) as String

            let results = CSVParser().parse(text)
            XCTAssertNotNil(results, "should not be nil")
            if let colorList = results {
                XCTAssertNotNil(colorList.color(withKey: "Accent"), "there is no color 'Accent'")
                XCTAssertNotNil(colorList.color(withKey: "Background"), "there is no color 'Background'")
                XCTAssertNotNil(colorList.color(withKey: "Secondary"), "there is no color 'Secondary'")
                XCTAssertNotNil(colorList.color(withKey: "Theme"), "there is no color 'Theme'")
            }
        } else {
            XCTAssert(false, "cannot get file URL")
        }

    }
    
}
