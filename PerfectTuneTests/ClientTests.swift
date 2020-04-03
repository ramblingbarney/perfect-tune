//
//  ClientTests.swift
//  PerfectTuneTests
//
//  Created by The App Experts on 02/03/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import XCTest
@testable import PerfectTune

class ClientTests: XCTestCase {

    let defaultTimeout = 15.0
    var systemUnderTest: LastFMClient!

    override func setUp() {
        systemUnderTest = LastFMClient()
    }

    override func tearDown() {
        systemUnderTest = nil
    }

    func testValidAPIConnectionWithNoSearchTerm() {

        let request = LastFMRequest.albumSearch(userSearchTerm: nil)
        let promise = expectation(description: "Valid API Connection")

        systemUnderTest.getFeed(from: request) { _ in
            promise.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }

    func testReceivedDataFromServerWithNoSearchTerm() {

        let request = LastFMRequest.albumSearch(userSearchTerm: nil)
        let promise = expectation(description: "Received Data from API")
        var connectionResult: Result<Data, APIError>?

        systemUnderTest.getFeed(from: request) { result in
            connectionResult = result
            promise.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout, handler: nil)

    }

    func testValidAPIConnectionWithSearchTerm() {

        let request = LastFMRequest.albumSearch(userSearchTerm: "pearl jam")
        let promise = expectation(description: "Valid API Connection")

        systemUnderTest.getFeed(from: request) { _ in
            promise.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }

    func testReceivedDataFromServerWithSearchTerm() {

        let request = LastFMRequest.albumSearch(userSearchTerm: "pearl jam")
        let promise = expectation(description: "Received Data from API")
        var connectionResult: Result<Data, APIError>?

        systemUnderTest.getFeed(from: request) { result in
            connectionResult = result
            promise.fulfill()
        }

        waitForExpectations(timeout: defaultTimeout, handler: nil)

        guard let actualResult = connectionResult else { return XCTFail("test Received Data From Server With Search Term") }

        switch actualResult {
        case .success: break
        case .failure(let error): XCTFail(error.localizedDescription)
        }
    }
}
