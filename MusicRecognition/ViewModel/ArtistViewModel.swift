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
        return "\(artist.songs?.count) Songs"
    }
    
    var artistAlbumCount:String?{
        return "\(artist.albums?.count) Albums"
    }
}
