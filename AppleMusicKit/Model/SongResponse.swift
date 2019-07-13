//
//  SongResponse.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/9/19.
//

import Foundation

public struct SongResponse: Decodable {
    var next: URL?
    var data: [Song]
}

public struct Song: Decodable {
    var id: String
    var attributes: SongAttributes
}

public struct SongAttributes: Decodable {
    var name: String?
    var url: URL?
    var artistName: String?
    var artwork: Artwork?
    var album: String?
    var playParams: PlayParams
}

public struct PlayParams: Decodable {
    var id: String
    var kind: String
}
