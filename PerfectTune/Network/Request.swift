//
//  Request.swift
//  PerfectTune
//
//  Created by The App Experts on 22/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

// Base definition of a 'Request'
protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queries: [URLQueryItem] { get }
}
extension Endpoint {
    
    // used to create a URL
    var urlComponents: URLComponents? {
        
        guard var components = URLComponents(string: base)  else { return nil }
        components.path = path
        components.queryItems = queries
        return components
    }
    
    // Used to create URLReqest
    var request: URLRequest? {
        guard let url = urlComponents?.url else { return nil }
        return URLRequest(url: url)
    }
}

enum LastFMRequest {
    case albumSearch(userSearchTerm: String?)
}

extension LastFMRequest: Endpoint {
    
    var base: String {
        return "http://ws.audioscrobbler.com"
    }
    
    var queries: [URLQueryItem] {
        
        // The API is told we need JSON format data back
        var params = [URLQueryItem(name: "format", value: "json")]
        
        switch self {
        case .albumSearch(let x):
            
            // We append some search tags
            if let term = x, !term.isEmpty {
                params.append(URLQueryItem(name: "method", value: "album.search"))
                params.append(URLQueryItem(name: "album", value: term))
                params.append(URLQueryItem(name: "api_key", value: valueForAPIKey(named:"API_KEY")))
            }
            
        }
        
        return params
    }
    
    var path: String {
        
        switch self {
        case .albumSearch(_): return "/2.0/"
        }
    }
    
}
