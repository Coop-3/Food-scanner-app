import XCTest
@testable import ExpiTrack

final class FoodStatusTests: XCTestCase {

    func testFreshStatus() {
        let date = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        let result = FoodStatus.status(for: date)
        XCTAssertEqual(result, .fresh)
    }

    func testExpiringSoonStatus() {
        let date = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        let result = FoodStatus.status(for: date)
        XCTAssertEqual(result, .expiringSoon)
    }

    func testExpiredStatus() {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let result = FoodStatus.status(for: date)
        XCTAssertEqual(result, .expired)
    }
}
