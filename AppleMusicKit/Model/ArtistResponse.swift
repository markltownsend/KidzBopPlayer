//
//  ArtistResponse.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

public struct ArtistResponse: Decodable {
    var data: [Artist]
}

public struct Artist: Decodable {
    var attributes: ArtistAttributes
    var relationships: ArtistRelationships
}

public struct ArtistAttributes: Decodable {
    var name: String
}

public struct ArtistRelationships: Decodable {
    var albums: AlbumResponse
}


