//
//  Client.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import UIKit.UIImage

// A list of possible errors, to be used with the ENUMs above
enum APIError: Error {

    case requestFailed
    case invalidData
    case invalidRequest
    case invalidImageURL
    case responseUnsuccessful

    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .invalidRequest: return "Invalid Request"
        case .invalidImageURL: return "Invalid Image URL"
        case .responseUnsuccessful: return "Response Unsuccessful"
        }
    }
}

// A simpel protocol for a simple client
protocol APIClient {

    // A client uses a session
    var session: URLSession { get }

    // a client fetches data
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void)

}

// An extension to the client to simply fetch
extension APIClient {

    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {

        let task = session.dataTask(with: request) { data, response, _ in

            // Check for a HTTP Response Status Code
            guard let httpResponse = response as? HTTPURLResponse else { return completion(.failure(.requestFailed)) }

            // Unwrap the data
            guard let data = data else { return completion(.failure(.invalidData)) }

            // Check it's 200
            switch httpResponse.statusCode {
            case 200...299:
                // Return the binary data
                completion(.success(data))

            default:
                completion(.failure(.responseUnsuccessful))
            }
        }
        task.resume()
    }
}

// A concrete implementation of the client
class LastFMClient: APIClient {

    let session: URLSession
    var imageCache: NSCache<NSString, UIImage>

    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
        self.imageCache = NSCache<NSString, UIImage>()
    }

    func getFeed(from profile: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) {

        guard let request = profile.request else { return completion(.failure(.invalidRequest)) }

        fetch(with: request, completion: completion)
    }

    // Fetching Image + Caching
    func fetchImage(for resultItem: Albums, completion: @escaping (Result<UIImage, APIError>) -> Void) {

        guard let imageUrl = URL(string: resultItem.value(forKeyPath: "imageUrl") as! String) else { return completion(.failure(.invalidImageURL))  }

        let imageKey = imageUrl.lastPathComponent as NSString

        if let image = imageCache.object(forKey: imageKey) {
            return completion(.success(image))
        }

        fetch(with: URLRequest(url: imageUrl)) { result in

            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return completion(.failure(.invalidData)) }
                return completion(.success(image))
            case .failure:
                return completion(.failure(.responseUnsuccessful))
            }
        }

    }
}
