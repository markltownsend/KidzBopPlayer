//
//  MKError.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

public struct MKError: Decodable {
    var code: String
    var detail: String?
    var id: String
    var status: String
    var title: String
}
