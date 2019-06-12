//
//  SearchResults.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

struct SearchResults: Decodable {
    var results: ResultsResponse
}

public struct ResultsResponse: Decodable {
    var artists: ArtistResponse?
    var songs: SongResponse?
}