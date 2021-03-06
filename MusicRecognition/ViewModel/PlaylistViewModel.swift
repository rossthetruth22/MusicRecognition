//
//  PlaylistViewModel.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/17/21.
//

import Foundation

class PlaylistViewModel{
    
    private let playlist:Playlist
    
    init(_ playlist:Playlist){
        self.playlist = playlist
    }
    
    var playlistName:String?{
        return playlist.name
    }
    var playlistLetter:String?{
        return "\(playlistName?.first ?? " ")"
    }
    
    var playlistSongCount:String{
        let songs = playlist.songs?.count != 1 ? "Songs" : "Song"
        return "\(playlist.songs?.count ?? 0) \(songs)"
    }
}
