import XCTest
@testable import NetflixClone

class SeeAllVCTests: XCTestCase {
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testGetSeeAll() throws {
        let sut = makeSUT()

        sut.viewDidLoad()
    }

    func makeSUT() -> SeeAllViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(identifier: "SeeAllViewController") as? SeeAllViewController
        else { return SeeAllViewController()}
        sut.loadViewIfNeeded()
        return sut
    }
}
