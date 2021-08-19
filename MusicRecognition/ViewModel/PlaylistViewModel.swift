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
        return "\(playlistName?.first)"
    }
    
    var playlistSongCount:String{
        return "\(playlist.songs?.count)"
    }
}
