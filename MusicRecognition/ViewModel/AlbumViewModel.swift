//
//  AlbumViewModel.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import Foundation

class AlbumViewModel{
    
    private let album:Album
    
    init(_ album:Album){
        self.album = album
    }
    
    var albumName:String?{
        return album.name
    }
    
    var albumArtist:String?{
        return album.artist?.name
    }
    
    var albumHeading:String?{
        return "\(albumName) By \(albumArtist)"
    }
    
//    var image:UIImage{
//        
//    }
//    
//    var albumCoverURL:URL{
//        
//    }
}
