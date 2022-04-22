import XCTest
@testable import NetflixClone

class SeeMoreVCTests: XCTestCase {
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testGetSeeMore() throws {
        let sut = SeeMoreViewController(genres: "", overview: "")
        sut.viewDidLoad()
    }
}
