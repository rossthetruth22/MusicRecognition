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
        var album:Album! = nil
        var artist:Artist! = nil
        
        
        do{
            print("trying to fetch an existing album for song \(songToSave.title)")
            let albumsFetched = try Album.fetchAlbums(songToSave.album, context: context)
            if albumsFetched.count >= 1{
                album = albumsFetched.first
                print("album is \(album.name)")
                do{
                    let artistsFetched = try Artist.getArtistByAlbum(album, context: context)
                    if artistsFetched.count >= 1{
                        artist = artistsFetched.first
                        print("artist for album is \(artist.name)")
                    }else{
                        print("didn't find an artist for the album")
                    }
                }catch{
                    print("Problem with artist fetch")
                }

            }else{
                print("no album found with this name.")
                album = Album.addAlbum(songToSave, context: context)
                //check if existing artist
                do{
                    var artists = [Artist]()
                    artists = try Artist.getArtist(songToSave.artist, context: context)
                    if artists.count >= 1{
                        artist = artists.first
                    }else{
                        artist = Artist.addArtist(songToSave, context: context)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                album.artist = artist
            }
        }catch{
            print("Problem with album fetch")
        }
        
        //let artist = Artist.addArtist(songToSave, context: context)
        //album.artist = artist
        song.artist = artist
        song.album = album
        song.albumName = album.name
        song.label = songToSave.label
        song.lyrics = songToSave
            .lyrics?.lyrics
    }
    
    static func getSongCounts(_ search:String?, backgroundContext: NSManagedObjectContext) throws -> Int{
        
        let fetchRequest :NSFetchRequest<Song> = Song.fetchRequest()
        if let search = search{
            let format = "name LIKE[c] %@"
            let predicate = NSPredicate(format: format, "*\(search)*")
            fetchRequest.predicate = predicate
        }
        
        var count = 0
        do{
           count = try backgroundContext.count(for: fetchRequest)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
            //throw CoreDataError.couldNotFetch
        }
        return count
    }
    
    static func fetchSongs(_search:String? = nil, context:NSManagedObjectContext) throws -> [Song]{
        let fetchRequest :NSFetchRequest<Song> = Song.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var songs = [Song]()
        do{
            songs = try context.fetch(fetchRequest)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
            //throw CoreDataError.couldNotFetch
        }
        return songs
    }
    

}
