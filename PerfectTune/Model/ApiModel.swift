//
//  ApiModel.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct RootNode: Codable {

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

    let albums: [Album]

    enum CodingKeys: String, CodingKey {
        case albums = "album"
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
