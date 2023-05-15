//
//  SongResponse.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/9/19.
//

import Foundation

public struct SongResponse: Decodable {
    public var next: URL?
    public var data: [Song]
}

public struct Song: Decodable, Identifiable {
    public var id: String
    public var attributes: SongAttributes
}

public struct SongAttributes: Decodable {
    public var name: String?
    public var url: URL?
    public var artistName: String?
    public var artwork: Artwork?
    public var album: String?
    public var playParams: PlayParams
}

public struct PlayParams: Decodable {
    public var id: String
    public var kind: String
}
