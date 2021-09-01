//
//  SongComponents.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/21/21.
//

import Foundation

struct SongComponents{
    var song:Song
    var album:Album
    var artist:Artist
    
    init(_ song: Song, _ artist: Artist, _ album:Album){
        self.song = song
        self.artist = artist
        self.album = album
    }
}
