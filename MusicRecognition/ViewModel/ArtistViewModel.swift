//
//  ArtistViewModel.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/17/21.
//

import Foundation

class ArtistViewModel{
    
    private let artist:Artist
    
    init(_ artist:Artist) {
        self.artist = artist
    }
    
    var artistName:String?{
        return artist.name
    }
    
    var artistSongCount:String?{
        let songs = artist.songs?.count != 1 ? "Songs" : "Song"
        return "\(artist.songs?.count ?? 0) \(songs)"
    }
    
    var artistAlbumCount:String?{
        let albums = artist.albums?.count != 1 ? "Albums" : "Album"
        return "\(artist.albums?.count ?? 0) \(albums)"
    }
}
