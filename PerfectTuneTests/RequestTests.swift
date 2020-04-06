//
//  RequestTests.swift
//  PerfectTuneTests
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import XCTest
@testable import PerfectTune

class RequestTests: XCTestCase {

    let expectedUrlComps = URLComponents(string: "http://ws.audioscrobbler.com/2.0/?format=json")!

    var systemUnderTest: LastFMRequest!

    override func setUp() {
        super.setUp()
        systemUnderTest = LastFMRequest.albumSearch(userSearchTerm: nil)
    }

    override func tearDown() {
        systemUnderTest = nil
        super.tearDown()
    }

    func testCreateAlbumSearchWithoutTerms_NonNilURLComps() {

        // When - We create the URLComponents
        let urlComps = systemUnderTest.urlComponents

        // Then - The URLComponents should be NOT be nil
        XCTAssertNotNil(urlComps)
    }

    func testCreateAlbumSearchWithoutTerms_NonNilURL() {

        // When - We create the URL
        let urlComps = systemUnderTest.urlComponents?.url

        // Then - The URL should be NOT be nil
        XCTAssertNotNil(urlComps)
    }

    func testCreateAlbumSearchWithSingleTerm_NonNilURLComps() {

        let sut = LastFMRequest.albumSearch(userSearchTerm: "Pearl jam")

        // When - We create the URLComponents
        let urlComps = sut.urlComponents

        // Then - The URLComponents should be NOT be nil
        XCTAssertNotNil(urlComps)
    }

    func testCreateAlbumSearchWithSingleTerm_NonNilURL() {

        let sut = LastFMRequest.albumSearch(userSearchTerm: "Pearl jam")

        // When - We create the URL
        let urlComps = sut.urlComponents?.url

        // Then - The URL should be NOT be nil
        XCTAssertNotNil(urlComps)
    }

    func testsValidHost() {

        guard let urlComps = systemUnderTest.urlComponents else {
            XCTFail("Invalid Comps \(String(describing: systemUnderTest.urlComponents))")
            return
        }

        let result = urlComps.host?.caseInsensitiveCompare(expectedUrlComps.host!)

        XCTAssertEqual(result, ComparisonResult.orderedSame, "Invalid API Host")
    }

    func testsValidPath() {

        guard let urlComps = systemUnderTest.urlComponents else {
            XCTFail("Invalid Comps \(String(describing: systemUnderTest.urlComponents))")
            return
        }

        let result = urlComps.path.caseInsensitiveCompare(expectedUrlComps.path)

        XCTAssertEqual(result, ComparisonResult.orderedSame, "Invalid API Path")
    }

}
