//
//  SongViewModel.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import Foundation

class SongViewModel{
    
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
    
    var trackCount:String{
        return "\(song.trackCount)"
    }
    
    var lyrics:String?{
        return song.lyrics
    }
    
    var duration:String?{
        return song.duration
    }
    
//    var image:UIImage?{
//        //grab ui image
//    }
    
    var songHeading:String{
        return "\(songName) By \(artistName)"
    }
}
