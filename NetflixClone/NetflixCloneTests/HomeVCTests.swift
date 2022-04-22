//
//  HomeVCTests.swift
//  NetflixCloneTests
//
//  Created by Hua Son Tung on 22/04/2022.
//

import XCTest
@testable import NetflixClone

class HomeVCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testEventHome() throws {
        let sut = makeSearchSUT()

        sut.viewDidLoad()
        sut.viewWillDisappear(true)
        sut.tvShowButtonTapped(UIButton())
        sut.movieButtonTapped(UIButton())
        sut.categoriesButtonTapped(UIButton())
        sut.addToMyListTapped(UIButton())
        sut.infoButtonTapped(UIButton())
        sut.seeAllTapped(Notification(name: Notification.Name.seeAllTappedNotiName))
        sut.allCategoryTapped()
        sut.mediaTypeCategoryTapped(mediaType: .movie, genreId: 28, genreName: "Action")
        sut.mediaTypeCategoryTapped(mediaType: .tvShow, genreId: 10759, genreName: "Action and Adventure")
    }

    func makeSearchSUT() -> HomeTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(identifier: "HomeTableViewController") as? HomeTableViewController
        else { return HomeTableViewController()}
        sut.loadViewIfNeeded()
        return sut
    }
}
