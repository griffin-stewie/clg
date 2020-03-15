//
//  ColorTests.swift
//  CoreTests
//
//  Created by Tatsuya Zushi on 2020/03/15.
//

import XCTest
@testable import Core

class ColorTests: XCTestCase {

    func testInitWithDictionaryRGB256() {
        let dict = [
            "name": "rgb color 255",
            "r": "255",
            "g": "255",
            "b": "255"
        ]

        let c = Color(dictionary: dict)

        let test = c.color
        let expected = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1.0)
        XCTAssertEqual(round(test.redComponent * 1000) / 1000, expected.redComponent)
        XCTAssertEqual(round(test.greenComponent * 1000) / 1000, expected.greenComponent)
        XCTAssertEqual(round(test.blueComponent * 1000) / 1000, expected.blueComponent)
        XCTAssertEqual(round(test.alphaComponent * 1000) / 1000, expected.alphaComponent)
    }

    func testInitWithDictionaryRGBA256() {
        let dict = [
            "name": "rgb color 255",
            "r": "255",
            "g": "255",
            "b": "255",
            "a": "100",
        ]

        let c = Color(dictionary: dict)

        let test = c.color
        let expected = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.392)
        XCTAssertEqual(round(test.redComponent * 1000) / 1000, expected.redComponent)
        XCTAssertEqual(round(test.greenComponent * 1000) / 1000, expected.greenComponent)
        XCTAssertEqual(round(test.blueComponent * 1000) / 1000, expected.blueComponent)
        XCTAssertEqual(round(test.alphaComponent * 1000) / 1000, expected.alphaComponent)
    }


    func testInitWithDictionaryRGBA() {
        let dict = [
            "name": "rgb color",
            "r": "1.0",
            "g": "0.5",
            "b": "0.5"
        ]

        let c = Color(dictionary: dict)
        
        let test = c.color
        let expected = NSColor(calibratedRed: 1, green: 0.5, blue: 0.5, alpha: 1.0)
        XCTAssertEqual(round(test.redComponent * 1000) / 1000, expected.redComponent)
        XCTAssertEqual(round(test.greenComponent * 1000) / 1000, expected.greenComponent)
        XCTAssertEqual(round(test.blueComponent * 1000) / 1000, expected.blueComponent)
        XCTAssertEqual(round(test.alphaComponent * 1000) / 1000, expected.alphaComponent)
    }

    func testInitWithDictionaryHex() {
        let dict = [
            "name": "background black hex",
            "hex": "191919"
        ]

        let c = Color(dictionary: dict)

        let test = c.color
        let expected = NSColor(calibratedRed: 0.098, green: 0.098, blue: 0.098, alpha: 1.0)
        XCTAssertEqual(round(test.redComponent * 1000) / 1000, expected.redComponent)
        XCTAssertEqual(round(test.greenComponent * 1000) / 1000, expected.greenComponent)
        XCTAssertEqual(round(test.blueComponent * 1000) / 1000, expected.blueComponent)
        XCTAssertEqual(round(test.alphaComponent * 1000) / 1000, expected.alphaComponent)

    }

    func testInitWithDictionaryHexRGBA() {
        let dict = [
            "name": "background black hex with A",
            "hex": "191919AA"
        ]

        let c = Color(dictionary: dict)

        let test = c.color
        let expected = NSColor(calibratedRed: 0.098, green: 0.098, blue: 0.098, alpha: 0.667)
        XCTAssertEqual(round(test.redComponent * 1000) / 1000, expected.redComponent)
        XCTAssertEqual(round(test.greenComponent * 1000) / 1000, expected.greenComponent)
        XCTAssertEqual(round(test.blueComponent * 1000) / 1000, expected.blueComponent)
        XCTAssertEqual(round(test.alphaComponent * 1000) / 1000, expected.alphaComponent)

    }

}
