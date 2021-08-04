//
//  Song+CoreDataClass.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/23/21.
//
//

import Foundation
import CoreData

@objc(Song)
public class Song: NSManagedObject {
    
    static func addSong(_ songToSave:AudDSong, context: NSManagedObjectContext){
        
        let song = Song(context: context)
        song.name = songToSave.title
        song.isrc = "12345"
        song.timestamp = Date()
        let album = addAlbum(songToSave, context: context)
        let artist = addArtist(songToSave, context: context)
        album.artist = artist
        song.artist = artist
        song.album = album
        song.albumName = album.name
        song.label = songToSave.label
        song.lyrics = songToSave
            .lyrics?.lyrics
    }
    
    static func addAlbum(_ song:AudDSong, context: NSManagedObjectContext) -> Album{
        
        let album = Album(context: context)
        album.name = song.album
        
        return album
    }
    
    static func addArtist(_ song:AudDSong, context: NSManagedObjectContext) -> Artist{
        let artist = Artist(context: context)
        artist.name = song.artist
        return artist
    }

}
