//
//  SearchResponse.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

public struct SearchResponse: MKResponseRoot {
    public var data: [MKResource]?
    public var errors: [MKError]?
    public var href: URL?
    public var next: URL?
    var results:[SearchResults]?
}
