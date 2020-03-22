//
//  FindingTaylorSwiftTests.swift
//  FindingTaylorSwiftTests
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import XCTest
@testable import FindingTaylorSwift

class FindingTaylorSwiftViewModelTests: XCTestCase {

    var systemUnderTest: OAuthListViewModel!

    override func setUp() {
        systemUnderTest = OAuthListViewModel(providers: OAuthProviders.providers)
    }

    override func tearDown() {
        systemUnderTest = nil
    }

    func testOAuthListViewModel_First_Equals_FaceBook() {

        XCTAssertEqual(systemUnderTest.providerList.first, "FaceBook")
    }

    func testOAuthListViewModel_Last_Equals_Meetup() {

        XCTAssertEqual(systemUnderTest.providerList.last, "Meetup")
    }

    func testOAuthListViewModel_Count_Equals_Fifteen() {

        XCTAssertEqual(systemUnderTest.providerList.count, 15)
    }
}
