//
//  File.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

public struct AlbumResponse: Decodable {
    var data: [Album]
}

public struct Album: Decodable {
    var artistName: String?
    var url: URL?
    var name: String?
}
