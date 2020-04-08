//
//  DataParser.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct DataParser {

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
