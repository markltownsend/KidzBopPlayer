//
//  AppleTokenGenerator.swift
//  AppleMusicKit
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation

public protocol AppleTokenGenerator {
    func generateDeveloperToken() -> String?
}
