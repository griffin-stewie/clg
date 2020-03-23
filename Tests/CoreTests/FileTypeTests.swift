//
//  FileTypeTests.swift
//  CoreTests
//
//  Created by griffin-stewie on 2020/03/23.
//  
//

import XCTest
@testable import Core

class FileTypeTests: XCTestCase {
    func testInitializeFromCLR() throws {
        let url = try Fixture().fileURL(forResource: "clg", ofType: "clr")
        let type = try FileType.init(from: url)
        XCTAssertEqual(type, .clr)
    }

    func testCLR() throws {
        let url = try Fixture().fileURL(forResource: "clg", ofType: "clr")
        let type = try FileType.init(from: url)
        print(url)
        print(url.isFileURL)
        let colorList = type.colorListFrom(url: url)
        XCTAssertNotNil(colorList)
    }
}
