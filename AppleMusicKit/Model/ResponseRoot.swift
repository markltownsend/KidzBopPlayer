//
//  ResponseRoot.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

public protocol MKResponseRoot: Decodable {
    var data: [MKResource]? {get set}
    var errors: [MKError]? {get set}
    var href: String? {get set}
    var next: String? {get set}
}
