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
        guard let albumName = albumName, let albumArtist = albumArtist else {return String()}
        return "\(albumName) By \(albumArtist)"
    }
    
    var albumSongCount:String?{
        let songs = album.songs?.count != 1 ? "Songs" : "Song"
        return "\(album.songs?.count ?? 0) \(songs)"
    }
    
    var imageURL:String?{
        //grab ui image
        return album.imageURL
    }
    var smallImageURL:String?{
        //grab ui image
        return album.smallImageURL
    }
    
    
    
//    var image:UIImage{
//        
//    }
//    
//    var albumCoverURL:URL{
//        
//    }
}
