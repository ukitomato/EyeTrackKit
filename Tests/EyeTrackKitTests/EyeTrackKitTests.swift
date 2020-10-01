import XCTest
@testable import EyeTrackKit

final class EyeTrackKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EyeTrackKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
