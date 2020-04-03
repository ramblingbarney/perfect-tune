//
//  CoreDataTests.swift
//  PerfectTuneTests
//
//  Created by The App Experts on 03/04/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import XCTest
import CoreData

private struct DataParser {

    /// A Generic parser to serialize JSON data into usbale objects model ojects
    ///
    /// - Parameters:
    ///   - data: the JSON data to parse
    ///   - type: The type to parse into, it MUST conform to the Decodable protocol
    /// - Returns: serialize model object
    /// - Throws: An error if any value throws an error during decoding.
    static func parse<T>(_ data: Data, type: T.Type) throws -> T where T: Decodable {
        let decoder = JSONDecoder()

        // For decoding the date
        // Flicke returns the date in iSO8601 format
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}

private struct RootNode: Codable {

    let results: Root?

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Root: Codable {

    let attr: Attr
    let albumMatches: AlbumMatch
    let opensearchQuery: OpensearchDetail
    let opensearchitemsPerPage: String?
    let opensearchstartIndex: String?
    let opensearchtotalResults: String?

    enum CodingKeys: String, CodingKey {
        case attr = "@attr"
        case albumMatches = "albummatches"
        case opensearchQuery = "opensearch:Query"
        case opensearchitemsPerPage = "opensearch:itemsPerPage"
        case opensearchstartIndex = "opensearch:startIndex"
        case opensearchtotalResults = "opensearch:totalResults"
    }
}

struct AlbumMatch: Codable {

    let album: [Album]

    enum CodingKeys: String, CodingKey {
        case album
    }
}

struct Album: Codable {

    let artist: String
    let image: [Image]
    let mbid: String
    let name: String
    let streamable: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case artist
        case image
        case mbid
        case name
        case streamable
        case url
    }
}

struct Attr: Codable {

    let forField: String

    enum CodingKeys: String, CodingKey {
        case forField = "for"
    }
}

struct OpensearchDetail: Codable {

    let text: String?
    let role: String?
    let searchTerms: String?
    let startPage: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role = "role"
        case searchTerms = "searchTerms"
        case startPage = "startPage"
    }
}

struct Image: Codable {

    let text: String
    let size: String

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size = "size"
    }
}

class CoreDataTests: XCTestCase {

    var systemUnderTest: MockCoreDataModel!
    private var searchResults: Root!

    override func setUp() {
        super.setUp()
        systemUnderTest = MockCoreDataModel(MockCoreDataController.shared)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
