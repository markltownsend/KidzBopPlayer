//
//  SongViewModel.swift
//  KidzBopPlayer
//
//  Created by Mark Townsend on 9/3/19.
//

import Foundation
import AppleMusicKit
import Combine

public class SongListViewModel {

    @Published var songs: [SongResponse]?

    

    func configure(_ cell: SongCell, model: SongResponse) {

    }
}
