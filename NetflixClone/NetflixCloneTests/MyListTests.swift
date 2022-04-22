//
//  MyListTests.swift
//  NetflixCloneTests
//
//  Created by Hua Son Tung on 22/04/2022.
//
import XCTest
@testable import NetflixClone

class MyListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testMyListEvent() throws {
        let sut = makeSearchSUT()

        sut.viewDidLoad()
        let myListTableViewCell = MyListTableViewCell()
        myListTableViewCell.awakeFromNib()
        myListTableViewCell.setSelected(true, animated: false)
        myListTableViewCell.setContentForCell(cell: MyListTableViewCell(), indexPath: IndexPath(index: 0), array: [MyList]())
        sut.myListTapped()
        sut.searchButtonTapped()
        sut.fetchDataFromCoreData()
    }

    func makeSearchSUT() -> MyListTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(identifier: "MyListTableViewController") as? MyListTableViewController
        else { return MyListTableViewController()}
        sut.loadViewIfNeeded()
        return sut
    }
}
