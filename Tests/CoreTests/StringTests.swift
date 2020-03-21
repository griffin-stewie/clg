import XCTest
@testable import Core

final class StringTests: XCTestCase {
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
