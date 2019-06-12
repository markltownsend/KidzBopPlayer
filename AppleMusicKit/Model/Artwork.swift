//
//  File.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/9/19.
//

import Foundation

public struct Artwork: Decodable {
    var width: Int?
    var height: Int?
    var url: String?
    var bgColor: String?
    var textColor1: String?
    var textColor2: String?
    var textColor3: String?
    var textColor4: String?

    func url(with width: Int, height: Int) -> URL? {
        guard let url = url else { return nil }
        let urlString = url.replacingOccurrences(of: "{w}", with: "\(width)")
            .replacingOccurrences(of: "{h}", with: "\(height)")
        return URL(string: urlString)
    }
}
