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

    public enum Relationship: String {
        case artists = "artists"
        case albums = "albums"
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
            @unknown default:
                print("unknown case")
            }
        }
    }

    public func searchSongs(term: String,
                            relationships: [Relationship]? = nil,
                            limit: Int? = 25,
                            songs: [Song]? = [Song](),
                            completion: @escaping (Result<[Song], AppleMusicKitError>) -> Void) {
        search(term: term,
               types:[.songs],
               relationships: relationships,
               limit: limit) { [weak self] (result) in
            switch result {
            case let .success(response):
                let songs = self?.getSongs(fromResponse: response)
                DispatchQueue.main.async {
                    completion(.success(songs ?? []))
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    public func search(term: String,
                       types: [SearchType]? = nil,
                       relationships: [Relationship]? = nil,
                       limit: Int? = 25,
                       completion: @escaping (Result<ResultsResponse?, AppleMusicKitError>) -> Void) {
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

        if let relationships = relationships {
            var relValue = [String]()
            for rel in relationships {
                relValue.append(rel.rawValue)
            }
            queryItems.append(URLQueryItem(name: "include", value: relValue.joined(separator: ",")))
        }

        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        
        urlComponents.queryItems = queryItems

        guard let urlRequest = urlComponents.url,
            let request = appleMusicRequest(with: urlRequest) else {
                DispatchQueue.main.async {
                    completion(.failure(.badResponse()))
                }
            return
        }

        print("request: \(String(describing: request.url?.absoluteString))")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.badResponse(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(String(describing: response))")
                    DispatchQueue.main.async {
                        completion(.failure(.badResponse(error)))
                    }
                    return
            }

            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResults.self, from: data)
                print(searchResults)
                DispatchQueue.main.async {
                    completion(.success(searchResults.results))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.badResponse(error)))
                }
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

    func page<T: Decodable>(with url: String, urlRequest: URLRequest, limit:Int? = 25, completion: @escaping ([T]?) -> Void) {
        guard let fullURL = URL(string: "\(baseUrl)\(url)") else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: fullURL) { (data, response, error) in
            if let error = error {
                print("Error paging: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let songs = try decoder.decode([T].self, from: data)
                
            } catch {
                print("Error paging: \(error)")
                return
            }
        }
        dataTask.resume()
    }

    func getSongs(fromResponse: ResultsResponse?) -> [Song] {
        guard let response = fromResponse else { return [] }

        if let songsResponse = response.songs {
            return songsResponse.data
        } else {
            return []
        }
    }
}

