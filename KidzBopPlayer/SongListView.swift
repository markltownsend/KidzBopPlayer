//
//  SongListView.swift
//  KidzBopPlayer
//
//  Created by Mark Townsend on 9/3/19.
//

import SwiftUI
import URLImage
import AppleMusicKit

struct SongRow: View {
    @State var song: Song

    var body: some View {
        HStack {
            if song.attributes.url != nil {
                URLImage(song.attributes.artwork!.url(with: 100, height: 100)!)
                .frame(width: 100.0, height: 100.0, alignment: .center)
            }
            VStack {
                Text("\(song.attributes.name!)").bold()
                if song.attributes.album != nil {
                    Text("\(song.attributes.album!)")
                }
            }
        }
    }
    
}

struct SongListView: View {
    @State var songs = [Song]()
    let appleMusicManager = AppleMusicManager.shared
    
    var body: some View {
        NavigationView {
            List(songs) { song in
                SongRow(song: song)
            }
            .navigationBarTitle(Text("Songs"))
            .onAppear() {
                AppleMusicManager.shared.search(term: "Kidz Bop Kids",types: [.songs]) { result in
                    switch result {
                    case let .success(response):
                        self.songs = response!.songs!.data
                    case let .failure(error):
                        print("\(error)")
                    }
                }
            }
        }
    }
}

// MARK: - Preview code
struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}


