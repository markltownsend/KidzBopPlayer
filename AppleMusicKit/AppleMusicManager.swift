//
//  AppleMusicManager.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 10/11/18.
//

import Foundation
import StoreKit
import Combine

public enum AppleMusicKitError: Error {
    case badResponse(_ error:Error? = nil)
    case badRequest(_ error:Error? = nil)
    case emptyResults(_ error:Error? = nil)
}

final public class AppleMusicManager {
    static public let shared = AppleMusicManager()

    let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
    private var developerToken: String?
    private var baseUrl = "https://api.music.apple.com/v1"
    private var storefront: String {
        let locale = Locale.current
        if let regionCode = locale.regionCode {
            return regionCode.lowercased()
        } else {
            return "us"
        }
    }
    private var catalog = "catalog"

    private var fullBaseUrl: String {
        return "\(baseUrl)/\(catalog)/\(storefront)"
    }

    public enum SearchType: String {
        case artists = "artists"
        case albums = "albums"
        case playlists = "playlists"
        case songs = "songs"
    }

    private init() {}
            
    public func setDeveloperToken(_ token: String) {
        developerToken = token
    }

    public func requestAuthorization(parentViewController: UIViewController) {
        SKCloudServiceController.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            case .restricted:
                print("restricted")
            case .notDetermined:
                print("not determined")

            }
        }
    }

    public func search(term: String, types:[SearchType]? = nil, completion: @escaping (Result<ResultsResponse?, AppleMusicKitError>) -> Void) {
        guard let url = URL(string: "\(fullBaseUrl)/search"),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                completion(.failure(.badRequest()))
            return
        }

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "term", value: term))

        if let types = types {
            var typeValue = [String]()
            for type in types {
                typeValue.append(type.rawValue)
            }
            queryItems.append(URLQueryItem(name: "types", value: typeValue.joined(separator: ",")))
        }

        urlComponents.queryItems = queryItems

        guard let urlRequest = urlComponents.url,
            let request = appleMusicRequest(with: urlRequest) else {
                completion(.failure(.badRequest()))
            return
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(.failure(.badResponse(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    completion(.failure(.badResponse(error)))
                    return
            }

            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResults.self, from: data)
                print(searchResults)
                completion(.success(searchResults.results))
            } catch {
                print(error)
                completion(.failure(.badResponse(error)))
                return
            }
        }
        dataTask.resume()
    }
}

// MARK: Private Methods
fileprivate extension AppleMusicManager {
    func appleMusicRequest(with url: URL) -> URLRequest? {
        guard let token = developerToken else { return nil }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
}
