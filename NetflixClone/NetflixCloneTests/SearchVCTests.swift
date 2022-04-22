import XCTest
@testable import NetflixClone

class SearchVCTests: XCTestCase {
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testGetSearchList() throws {
        let sut = makeSearchSUT()
        let searchTextField = sut.searchTextField
        var returnArray = [ListedItem]()
        let endPoint = EndPoint.search(query: "batman", page: 1)
        let promise = expectation(description: "Status Code: 200")
        guard let tableView = sut.tableView else { return }
        let contentHeight = sut.tableView.contentSize.height
        tableView.contentOffset.y = contentHeight - tableView.frame.height + 150
        sut.scrollViewDidEndDragging(tableView, willDecelerate: true)
        sut.loadMoreData()

        searchTextField?.text = "batman"
        searchTextField?.sendActions(for: .editingDidEnd)

        sut.viewDidLoad()

        let task = URLSession.shared.dataTask(with: endPoint.url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(ListedItems.self, from: data)
                promise.fulfill()
            } catch {
                XCTFail("Status Code: \(response)")
            }
        }
        task.resume()
        wait(for: [promise], timeout: 5)
        sut.itemTapped(id: 634649, isMovie: true)
    }

    func testGetEmptySearchList() throws {
        let sut = makeSearchSUT()
        let searchTextField = sut.searchTextField
        let endPoint = EndPoint.search(query: "asdasdasdasdasgfasf", page: 1)
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/634649?api_key=4c8686d0d2ee37d6f04bd0eca7ca6efb&language=en-US") else { return }
        searchTextField?.text = ""
        searchTextField?.sendActions(for: .editingDidEnd)
        searchTextField?.sendActions(for: .touchDown)

        sut.viewDidLoad()

        var statusCode: Int?
        var responseError: Error?
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let results = try JSONDecoder().decode(ListedItems.self, from: data ?? Data())
                XCTAssertFalse(results.results.isEmpty)
            } catch {
                responseError = error
                statusCode = (response as? HTTPURLResponse)?.statusCode
            }
        }
        task.resume()

        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, nil)
    }

    func makeSearchSUT() -> SearchTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(identifier: "SearchTableViewController") as? SearchTableViewController
        else { return SearchTableViewController()}
        sut.loadViewIfNeeded()
        return sut
    }
}
