//
//  File.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/13/21.
//

import Foundation

class IDViewModel{
    
    private let song:ACRMusic
    
    init(_ song:ACRMusic){
        self.song = song
    }
    
    var songName:String{
        return song.title
    }
    
    var albumName:String{
        return song.album.name
    }
    
    var artistName:String{
        return song.artists.first!.name
    }
    
}
