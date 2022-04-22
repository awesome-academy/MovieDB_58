import XCTest
@testable import NetflixClone

class DetailVCTests: XCTestCase {
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testGetDetail() throws {
        let sut = makeDetailSUT()

        sut.viewDidLoad()
        sut.setContentForItemBannerCell(cell: ItemBannerTableViewCell())
        sut.setContentForCastCell(cell: ItemCastTableViewCell(), castArray: [Cast]())
        sut.setContentForMoreLikeThisCell(cell: MoreLikeThisTableViewCell(), moreLikeThisArray: [ListedItem]())

        apiRepo.getTvDetail(id: 60059, viewController: HomeTableViewController()) { (tvDetail: TvDetail) in
            XCTAssertFalse(tvDetail.name == nil)
            DispatchQueue.main.async {
                // More like this cell
                let moreLikeThisCell = MoreLikeThisTableViewCell()
                moreLikeThisCell.awakeFromNib()
                moreLikeThisCell.layoutSubviews()
                moreLikeThisCell.setSelected(true, animated: true)

                // Item cast cell
                let itemCastCell = ItemCastTableViewCell()
                itemCastCell.awakeFromNib()
                itemCastCell.setSelected(true, animated: true)
                itemCastCell.layoutSubviews()
                itemCastCell.setContentForCell(cell: ItemCastCollectionViewCell(), indexPath: IndexPath(index: 0))
                let itemCastCollectionViewCell = ItemCastCollectionViewCell()
                itemCastCollectionViewCell.awakeFromNib()
            }
        }

        apiRepo.getMovieDetail(id: 634649, viewController: HomeTableViewController()) { (movieDetail: MovieDetail) in
            XCTAssertFalse(movieDetail.title == nil)
            DispatchQueue.main.async {
                // Interactive cell
                let interactiveCell = InteractiveTableViewCell()
                let nameString = "Spider-Man: No Way Home"
                let posterPath = "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg"
                let indexPath = IndexPath(index: 0)
                interactiveCell.awakeFromNib()
                interactiveCell.setSelected(true, animated: true)
                interactiveCell.setContentForInteractiveCell(cell: interactiveCell, indexPath: indexPath, id: 634649, name: nameString, posterPath: posterPath, isMovie: true, inMyList: false)
                interactiveCell.myListButtonTapped(UIButton())
            }
        }
    }

    func makeDetailSUT() -> DetailTableViewController {
        let sut = DetailTableViewController(id: 60059, isMovie: false, playVideo: false)
        sut.loadViewIfNeeded()
        return sut
    }

}
