//
//  ApiKeys.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//
import Foundation

struct SecretKeys: Codable {
    var apiKey: String
    var secretKey: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "API_KEY"
        case secretKey = "SECRET_KEY"
    }
}

internal func valueForAPIKey(key: String) -> String {

    var returnValue = ""

    if  let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let preferences = try? PropertyListDecoder().decode(SecretKeys.self, from: xml) {

        switch key {
        case "apiKey":
            returnValue = preferences.apiKey
        case "secretKey":
            returnValue = preferences.secretKey
        default:
            print("no api keys or secrets matched")
        }
    }
    return returnValue
}
