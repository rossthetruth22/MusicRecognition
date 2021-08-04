//
//  IdentifyViewModel.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/4/21.
//

import Foundation

class IdentifyViewModel{
    
    private let song:AudDSong
    
    init(_ song:AudDSong){
        self.song = song
    }
    
    var songName:String{
        return song.title
    }
    
    var albumName:String{
        return song.album
    }
    
    var artistName:String{
        return song.artist
    }
    
    var songLyrics:String?{
        return song.lyrics?.lyrics
    }
    
}
