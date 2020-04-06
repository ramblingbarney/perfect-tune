//
//  CoreDataTests.swift
//  PerfectTuneTests
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import XCTest
import CoreData
@testable import PerfectTune

class CoreDataTests: XCTestCase {

    var systemUnderTest: MockCoreDataModel!
    var coreDataController: MockCoreDataController!
    private var searchResults: Root!

    override func setUp() {
        super.setUp()
        systemUnderTest = MockCoreDataModel(MockCoreDataController.shared)
    }

    override func tearDown() {

        super.tearDown()
        systemUnderTest.deleteAllData("Albums")
        systemUnderTest.deleteAllData("Searches")
    }

    func testCheckEmpty() {
        if let systemUnderTest = self.systemUnderTest {
            systemUnderTest.fetchAllAlbums()
            XCTAssertEqual(systemUnderTest.items.count, 0)
        } else {
            XCTFail("test Check Empty")
        }
    }

    func testAddFortyNineAlbums() {
        if let systemUnderTest = self.systemUnderTest {

            do {
                let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "AlbumData", ofType: "json")!
                let albumData = try Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
                let data =  try DataParser.parse(albumData, type: RootNode.self)
                searchResults = data.results
                try systemUnderTest.saveSearchAlbums(responseData: searchResults)
            } catch {
                print(error)
            }

            XCTAssertEqual(systemUnderTest.items.count, 49)
        } else {
            XCTFail("test Add Forty Nine Albums")
        }
    }

    func testFetchAllAlbums() {
        if let systemUnderTest = self.systemUnderTest {

            do {
                let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "AlbumData", ofType: "json")!
                let albumData = try Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
                let data =  try DataParser.parse(albumData, type: RootNode.self)
                searchResults = data.results
                try systemUnderTest.saveSearchAlbums(responseData: searchResults)
                systemUnderTest.fetchAlbumsByKeyword(searchTerm: "Believe")
            } catch {
                print(error)
            }

            XCTAssertEqual(systemUnderTest.items.count, 49)
        } else {
            XCTFail("test Fetch All Albums")
        }
    }

    func testFetchAlbumsKeyword() {
        if let systemUnderTest = self.systemUnderTest {

            do {
                let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "AlbumData", ofType: "json")!
                let albumData = try Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
                let data =  try DataParser.parse(albumData, type: RootNode.self)
                searchResults = data.results
                try systemUnderTest.saveSearchAlbums(responseData: searchResults)
                systemUnderTest.fetchAllAlbums()
            } catch {
                print(error)
            }

            XCTAssertEqual(systemUnderTest.items.count, 49)
        } else {
            XCTFail("test Fetch All Albums")
        }
    }
}
