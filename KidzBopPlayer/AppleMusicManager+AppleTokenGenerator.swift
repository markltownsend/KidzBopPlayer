//
//  AppleMusicManager+AppleTokenGenerator.swift
//  KidzBopPlayer
//
//  Created by Mark Townsend on 6/7/19.
//

import Foundation
import AppleMusicKit
import CupertinoJWT

extension AppleMusicManager: AppleTokenGenerator {
    private var DAY_IN_SEC: TimeInterval {
        86400.0
    }
    public func generateDeveloperToken() -> String? {
        let secret = """
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgRjPfeFHd0n6pNcHU
oAdYIG2/P6Ms/2B6gtwWTQ+brc6gCgYIKoZIzj0DAQehRANCAAS005zyJrTS9x9k
vF12WiBiFeeqVurJdEHhAXVy6oMpz3XvzR6Drk2GsA9fBjSbZPMAadjuufP0/VYR
XMxusWit
-----END PRIVATE KEY-----
"""
        let jwt = JWT(keyID: "X5734CYXMA", teamID: "55AT6EYVPW", issueDate: Date(), expireDuration: 6 * 30 * DAY_IN_SEC)

        do {
            let token = try jwt.sign(with: secret)
            print("Developer Token: \n\(token)")
            return token
        } catch {
            print(error)
        }
        return nil
    }
}
