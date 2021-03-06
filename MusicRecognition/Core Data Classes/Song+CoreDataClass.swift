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
    
    static func addSong(_ songToSave:SongComponents, context: NSManagedObjectContext){
        
        var song = songToSave.song
        //var song = Song(context: context)
        song = songToSave.song
        let newAlbum = songToSave.album
        let newArtist = songToSave.artist
        //let song = Song(context: context)
        //let musicBrainz = songToSave.musicbrainz
        //song.name = songToSave.title
        //song.isrc = "12345"
        song.timestamp = Date()
        //song.mbid = musicBrainz?.first?.id
        var album:Album! = nil
        var artist:Artist! = nil
        
        
        do{
            print("trying to fetch an existing album for song \(song.name)")
            //let albumsFetched = try Album.fetchAlbums(songToSave.album, context: context)
            let albumsFetched = try Album.fetchAlbums(newAlbum.name, albumMbid: newAlbum.mbid, context: context)
            //let albumsFetched = try Album.fetchAlbums(albumMbid: (musicBrainz?.first!.releases.first!.id)!, context: context)
            if albumsFetched.count >= 1{
                album = albumsFetched.first
                print("album is \(album.name)")
                
                //if you get an album, just grab the artist from the album
                artist = album.artist
                //??
                print("artist for album is \(artist.name)")
                
//                do{
//                    //let artistsFetched = try Artist.getArtistByAlbum(album, context: context)
//                    let artistsFetched = try Artist.getArtistByAlbum(albumMbid: album.mbid!, context: context)
//                    if artistsFetched.count >= 1{
//                        artist = artistsFetched.first
//                        print("artist for album is \(artist.name)")
//                    }else{
//                        print("didn't find an artist for the album")
//                    }
//                }catch{
//                    print("Problem with artist fetch")
//                }

            }else{
                print("no album found with this name.")
                //album = Album.addAlbum(songToSave, context: context)
                
                album = newAlbum
                
                //album = Album.addAlbum(songToSave, context: context)
                //check if existing artist
                do{
                    var artists = [Artist]()
                    //artists = try Artist.getArtist(songToSave.artist, context: context)
                    //artists = try Artist.getArtist(musicBrainz?.first?.artistCredit.first?.artist.id, context: context)
                    artists = try Artist.getArtist(newArtist.name, artistMbid: newArtist.mbid, context: context)
                    if artists.count >= 1{
                        artist = artists.first
                    }else{
                        //artist = Artist.addArtist(songToSave, context: context)
                        //artist = Artist.addArtist(songToSave, context: context)
                        artist = newArtist
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
        song.artistName = artist.name
        //song.label = songToSave.label
        //song.lyrics = songToSave.lyrics?.lyrics
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
    
    static func getSongCounts(mbid:String, backgroundContext: NSManagedObjectContext) throws -> Int{
        
        let fetchRequest :NSFetchRequest<Song> = Song.fetchRequest()

        let format = "mbid MATCHES %@"
        let predicate = NSPredicate(format: format, mbid)
        fetchRequest.predicate = predicate
        
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
    
    static func getSongCounts(_ search:String?, songMbid:String?, context:NSManagedObjectContext) throws -> Int{
        
        let fetchRequest :NSFetchRequest<Artist> = Artist.fetchRequest()
        
        var predicates = [NSPredicate]()
        
        if let songMbid = songMbid{
            let format = "mbid MATCHES %@"
            let predicate = NSPredicate(format: format, songMbid)
            predicates.append(predicate)
        }
        
        if let search = search{
            let format = "name LIKE[c] %@"
            let predicate = NSPredicate(format: format, "*\(search)*")
            predicates.append(predicate)
        }
        
        if predicates.count > 1{
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }else if predicates.count == 1{
            fetchRequest.predicate = predicates.first!
        }
        
        var count = 0
        do{
           count = try context.count(for: fetchRequest)
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
    
    static func fetchAlbumSongs(_ album:Album, context:NSManagedObjectContext) throws -> [Song]{
            
        let fetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "album == %@", album)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "trackCount", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        var songs = [Song]()
        do {
            songs = try context.fetch(fetchRequest)
        }catch{
            
        }
        return songs
    }
    
    static func fetchArtistSongs(_ artist:Artist, context:NSManagedObjectContext) throws -> [Song]{
            
        let fetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "artist == %@", artist)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        var songs = [Song]()
        do {
            songs = try context.fetch(fetchRequest)
        }catch{
            
        }
        return songs
    }
    
    static func fetchPlaylistSongs(_ playlist:Playlist, context:NSManagedObjectContext) throws -> [Song]{
        
        let fetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "ANY playlist == %@", playlist)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        var songs = [Song]()
        do {
            songs = try context.fetch(fetchRequest)
        }catch{
            
        }
        return songs
        
    }
    
    static func fetchSongs(_ musicBrainz:MusicBrainz, context:NSManagedObjectContext) throws -> [Song]{
                
        let fetchRequest :NSFetchRequest<Song> = Song.fetchRequest()
        
        let format = "mbid MATCHES %@"
        let predicate = NSPredicate(format: format, "\(musicBrainz.id)")
        fetchRequest.predicate = predicate
        
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
