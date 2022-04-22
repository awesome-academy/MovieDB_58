import XCTest
@testable import NetflixClone

class ApiRepositoryTests: XCTestCase {
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testGetListTrending() throws {
        apiRepo.getList(listType: .trending, mediaType: .all, viewController: HomeTableViewController()) { (listedArray: ListedItems) in
            XCTAssertFalse(listedArray.results.isEmpty)
        }

        apiRepo.getList(listType: .trending, mediaType: .movie, viewController: HomeTableViewController()) { (listedArray: ListedItems) in
            XCTAssertFalse(listedArray.results.isEmpty)
        }

        apiRepo.getList(listType: .trending, mediaType: .tvShow, viewController: HomeTableViewController()) { (listedArray: ListedItems) in
            XCTAssertFalse(listedArray.results.isEmpty)
        }
    }

    func testGetDiscoverList() throws {
        apiRepo.getDiscoverList(mediaType: .movie, genreId: 28, viewController: HomeTableViewController()) { (listedArray: ListedItems) in
            XCTAssertFalse(listedArray.results.isEmpty)
        }

        apiRepo.getDiscoverList(mediaType: .tvShow, genreId: 10759, viewController: HomeTableViewController()) { (listedArray: ListedItems) in
            XCTAssertFalse(listedArray.results.isEmpty)
        }
    }

    func testGetGenreCategory() throws {
        let sut = makeCategorySUT()

        sut.viewDidLoad()

        apiRepo.getGenreCategory(mediaType: .tvShow, viewController: CategoryViewController()) { (genres: Genres) in
            XCTAssertFalse(genres.genres.isEmpty)
        }

        apiRepo.getGenreCategory(mediaType: .movie, viewController: CategoryViewController()) { (genres: Genres) in
            XCTAssertFalse(genres.genres.isEmpty)
        }
        let categoryCell = CategoryTableViewCell()
        categoryCell.awakeFromNib()
    }

    func testGetCreditCast() throws {
        apiRepo.getCreditCast(mediaType: .tvShow, id: 60059) { (result: Result<Casts, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.cast.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }

        apiRepo.getCreditCrew(mediaType: .tvShow, id: 60059) { (result: Result<Crews, Error>) in
            switch result {
            case .success(let success):
                XCTAssertTrue(success.crew.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }

        apiRepo.getCreditCast(mediaType: .movie, id: 634649) { (result: Result<Casts, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.cast.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }

        apiRepo.getCreditCrew(mediaType: .movie, id: 634649) { (result: Result<Crews, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.crew.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }
    }

    func testGetSimilarItem() throws {
        apiRepo.getSimilarItem(mediaType: .tvShow, id: 60059) { (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.results.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }

        apiRepo.getSimilarItem(mediaType: .movie, id: 634649) { (result: Result<ListedItems, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.results.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }
    }

    func testGetVideo() throws {
        apiRepo.getVideo(mediaType: .tvShow, id: 60059) { (result: Result<Videos, Error>) in
            switch result {
            case .success(let success):
                XCTAssertFalse(success.results.isEmpty)
            case .failure(let failure):
                XCTFail("\(failure)")
            }
        }
    }

    func makeCategorySUT() -> CategoryViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(identifier: "CategoryScreen") as? CategoryViewController
        else { return CategoryViewController()}
        sut.loadViewIfNeeded()
        return sut
    }
}
