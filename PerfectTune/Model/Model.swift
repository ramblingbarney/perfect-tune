//
//  Model.swift
//  PerfectTune
//
//  Created by The App Experts on 20/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct RootClass : Codable {

    let results : Result?

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Result : Codable {

    let attr : Attr
    let albummatches : Albummatche
    let opensearchQuery : OpensearchDetail
    let opensearchitemsPerPage : String?
    let opensearchstartIndex : String?
    let opensearchtotalResults : String?

    enum CodingKeys: String, CodingKey {
        case attr = "@attr"
        case albummatches
        case opensearchQuery = "opensearch:Query"
        case opensearchitemsPerPage = "opensearch:itemsPerPage"
        case opensearchstartIndex = "opensearch:startIndex"
        case opensearchtotalResults = "opensearch:totalResults"
    }
}

struct Albummatche : Codable {

    let album : [Album]?

    enum CodingKeys: String, CodingKey {
        case album = "album"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        album = try values.decodeIfPresent([Album].self, forKey: .album)
    }
}

struct Album : Codable {

    let artist : String?
    let image : [Image]?
    let mbid : String?
    let name : String?
    let streamable : String?
    let url : String?

    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case image = "image"
        case mbid = "mbid"
        case name = "name"
        case streamable = "streamable"
        case url = "url"
    }
}


struct Attr : Codable {

    let forField : String?

    enum CodingKeys: String, CodingKey {
        case forField = "for"
    }
}

struct OpensearchDetail : Codable {

    let text : String?
    let role : String?
    let searchTerms : String?
    let startPage : String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role = "role"
        case searchTerms = "searchTerms"
        case startPage = "startPage"
    }
}


struct Image : Codable {

    let text : String?
    let size : String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size = "size"
    }
}

