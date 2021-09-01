//
//  File.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/13/21.
//

import Foundation

class IDViewModel{
    
    private let song:Song
    
    init(_ song:Song){
        self.song = song
    }
    
    var songName:String?{
        return song.name
    }
    
    var albumName:String?{
        return song.albumName
    }
    
    var artistName:String?{
        return song.artistName
    }
    
}
