import XCTest
@testable import NetflixClone

class ComingSoonVCTests: XCTestCase {
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testGetComingSoonMovie() throws {
        let sut = makeComingSoonSUT()
        let button = UIButton()
        button.tag = 0

        sut.viewDidLoad()

        apiRepo.getComingSoonMovie(mediaType: .movie, page: 1) { (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.results.isEmpty)

                DispatchQueue.main.async {
                    let sutCell = ComingSoonTableViewCell()
                    sutCell.awakeFromNib()
                    sutCell.setSelected(true, animated: true)
                    sutCell.setContentForCell(indexPath: IndexPath(index: 0), comingSoonList: success.results)
                    sut.infoTapped(button)
                    sut.remindMeTapped(button)
                    sut.loadMoreData()
                }
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }
        sut.scrollViewDidEndDragging(sut.tableView, willDecelerate: true)
        sut.viewWillDisappear(true)
    }

    func makeComingSoonSUT() -> ComingSoonTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(identifier: "ComingSoonTableViewController") as? ComingSoonTableViewController
        else { return ComingSoonTableViewController()}
        sut.loadViewIfNeeded()
        return sut
    }
}
