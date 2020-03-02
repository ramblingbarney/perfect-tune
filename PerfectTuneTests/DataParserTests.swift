//
//  DataParserTests.swift
//  PerfectTuneTests
//
//  Created by The App Experts on 02/03/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import XCTest
@testable import PerfectTune

// For DataParsing im using a file which contains a sample reponse
// To make sure the API response does not mess up the tests
class DataParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyDataParserThrowsException() {
        
        // Given empty data
        let emptyData = Data()
        
        // When we parse, an exception should be thrown
        XCTAssertThrowsError(try DataParser.parse(emptyData, type: SimpleData.self))
        
    }
    
    func testInavlidDataParserThrowsException() {
        
        let invalidData = "Hello, world".data(using: .utf8)!
        
        XCTAssertThrowsError(try DataParser.parse(invalidData, type: SimpleData.self))
    }
    
    func testVaildSampleDataParserNoThrow() {
        
        let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "SampleData", ofType: "json")!
        let simpleData = try! Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
        
        XCTAssertNoThrow(try DataParser.parse(simpleData, type: SimpleData.self))
    }
    
    func testValidSampleDataParsedHasResults() {
        
        let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "SampleData", ofType: "json")!
        let simpleData = try! Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
        let someData = try! DataParser.parse(simpleData, type: SimpleData.self)
        
        XCTAssertEqual(someData.anInt, 42)
        
        XCTAssertGreaterThanOrEqual(someData.simpleSubData.count, 2)
    }
    
    func testSampleResponseDataParserNoThrow() {
        
        let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "sampleResponse", ofType: "json")!
        let simpleData = try! Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
        
        XCTAssertNoThrow(try DataParser.parse(simpleData, type: RootNode.self))
    }
    
    func testSampleResponseDataParsedHasResults() {
        
        let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "sampleResponse", ofType: "json")!
        let simpleData = try! Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
        let result = try! DataParser.parse(simpleData, type: RootNode.self)
        
        XCTAssertGreaterThanOrEqual(result.results!.albumMatches.album.count, 1)
    }
}

// MARK: - Simple Parsing Data
fileprivate struct SimpleData: Decodable  {
    var aString: String
    var anInt: Int
    var simpleSubData: [SimpleSubData]
}

fileprivate struct SimpleSubData: Decodable {
    var anotherString: String
    var aBool: Bool
    var aDouble: Double
}
