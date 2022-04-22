import XCTest
@testable import NetflixClone

class NetflixCloneTests: XCTestCase {

    var sut: URLSession?
    let apiRepo = APIRepository()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLSession(configuration: .default)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testResponseCode() throws {
        let urlString =
            "https://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1"
        guard let url = URL(string: urlString) else {
                    XCTFail("Not have url")
                    return
                }
        let promise = expectation(description: "Status Code: 200")

        let dataTask = sut?.dataTask(with: url) { _, response, error in
                    if let error = error {
                        XCTFail("Error: \(error.localizedDescription)")
                        return
                    } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        if statusCode == 200 {
                            promise.fulfill()
                        } else {
                            XCTFail("Status Code: \(statusCode)")
                        }
                    }
                }
                dataTask?.resume()
                wait(for: [promise], timeout: 5)
    }

    func testApiCallCompleted() throws {

        let urlString =
            "https://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1"
        guard let url = URL(string: urlString) else {
                    XCTFail("Not have url")
                    return
                }
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        let dataTask = sut?.dataTask(with: url) { _, response, error in
                statusCode = (response as? HTTPURLResponse)?.statusCode
                responseError = error
                promise.fulfill()
            }
            dataTask?.resume()
            wait(for: [promise], timeout: 5)

            XCTAssertNil(responseError)
            XCTAssertEqual(statusCode, 200)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
