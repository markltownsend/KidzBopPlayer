//
//  Item.swift
//  KidzBopPlayer
//
//  Created by Mark Townsend on 11/11/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
