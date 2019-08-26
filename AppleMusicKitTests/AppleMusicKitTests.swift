//
//  AppleMusicKitTests.swift
//  AppleMusicKitTests
//
//  Created by Mark Townsend on 10/7/18.
//

import XCTest
@testable import AppleMusicKit

class AppleMusicKitTests: XCTestCase {

    let api = AppleMusicManager.shared
    var token: String?

    override func setUp() {
        guard let token = api.generateDeveloperToken() else { return }
        self.token = token
        api.setDeveloperToken(token)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        let doneExpectation = expectation(description: "searchDone")
        api.search(term: "Kidz Bop") { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                print(error)
            }
            doneExpectation.fulfill()
        }

        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    func testSearchWithSongType() {
        let doneExpectation = expectation(description: "searchDone")
        api.search(term: "Kidz Bop", types: [.songs]) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case.failure(let error):
                print(error)
            }

            doneExpectation.fulfill()
        }

        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
