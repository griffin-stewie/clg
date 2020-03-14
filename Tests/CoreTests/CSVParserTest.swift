//
//  CSVParserTest.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/25.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import XCTest
import class Foundation.Bundle
@testable import Core

class CSVParserTest: XCTestCase {

    func testExample() {
        let text = """
                   Accent,218,40,64
                   Background,250,250,250
                   Secondary,100,99,98
                   Theme,28,26,24
                   """
        let results = CSVParser().parse(text)
        XCTAssertNotNil(results, "should not be nil")
        if let colorList = results {
            XCTAssertNotNil(colorList.color(withKey: "Accent"), "there is no color 'Accent'")
            XCTAssertNotNil(colorList.color(withKey: "Background"), "there is no color 'Background'")
            XCTAssertNotNil(colorList.color(withKey: "Secondary"), "there is no color 'Secondary'")
            XCTAssertNotNil(colorList.color(withKey: "Theme"), "there is no color 'Theme'")
        }
    }

}
