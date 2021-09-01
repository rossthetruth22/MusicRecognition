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
        let seconds = TimeInterval(song.length/1000)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        return formatter.string(from: seconds)
    }
    
    var imageURL:String?{
        //grab ui image
        return song.album?.imageURL
    }
    
    var smallImageURL:String?{
        //grab ui image
        return song.album?.smallImageURL
    }
    
    var songHeading:String{
        guard let songName = songName, let artistName = artistName else {return String()}
        
        return "\(songName) By \(artistName)"
    }
}
