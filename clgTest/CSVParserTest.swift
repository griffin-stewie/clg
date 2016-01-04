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

        var path = NSBundle(forClass: self.dynamicType).pathForResource("color", ofType: "csv")
        XCTAssertNotNil(path, "");

        if let path = path, let fileURL = NSURL(fileURLWithPath: path) {
            let text = NSString(contentsOfURL:fileURL , encoding: NSUTF8StringEncoding, error: nil) as! String

            var results = CSVParser().parse(text)
            XCTAssertNotNil(results, "should not be nil")
            if let colorList = results {
                XCTAssertNotNil(colorList.colorWithKey("Accent"), "there is no color 'Accent'")
                XCTAssertNotNil(colorList.colorWithKey("Background"), "there is no color 'Background'")
                XCTAssertNotNil(colorList.colorWithKey("Secondary"), "there is no color 'Secondary'")
                XCTAssertNotNil(colorList.colorWithKey("Theme"), "there is no color 'Theme'")
            }
        } else {
            XCTAssert(false, "cannot get file URL")
        }

    }
    
}
