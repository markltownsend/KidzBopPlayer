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
    public var href: String?
    public var next: String?
    var results:[SearchResults]?
}
