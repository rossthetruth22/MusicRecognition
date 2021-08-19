//
//  Artist+CoreDataClass.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/4/21.
//
//

import Foundation
import CoreData

@objc(Artist)
public class Artist: NSManagedObject {
    
    static func addArtist(_ song:AudDSong, context: NSManagedObjectContext) -> Artist{
        let artist = Artist(context: context)
        artist.name = song.artist
        artist.mbid = song.musicbrainz?.first?.releases.first?.id
        return artist
    }
    
//    static func addArtist(response:AudDResponse, context: NSManagedObjectContext) -> Artist{
//        let artist = Artist(context: context)
//        let song = response.result
//        artist.name = song.artist
//        artist.mbid = response.musicbrainz.releases.first?.id
//        return artist
//    }
    
    static func getArtist(_ search:String? = nil, context:NSManagedObjectContext) throws -> [Artist]{
        
        var artists = [Artist]()
        
        let fetchRequest :NSFetchRequest<Artist> = Artist.fetchRequest()
        
        if let search = search{
            let format = "name LIKE[c] %@"
            let predicate = NSPredicate(format: format, "*\(search)*")
            fetchRequest.predicate = predicate
        }
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        do{
            artists = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
            throw error
        }
        
        return artists
        
    }
    
    static func getArtist(artistMbid:String, context:NSManagedObjectContext) throws -> [Artist]{
        
        var artists = [Artist]()
        
        let fetchRequest :NSFetchRequest<Artist> = Artist.fetchRequest()
        
        let format = "mbid MATCHES %@"
        let predicate = NSPredicate(format: format, artistMbid)
        //let predicate = NSPredicate(format: format, artistMbid)
        fetchRequest.predicate = predicate

        
        do{
            artists = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
            throw error
        }
        
        return artists
        
    }
    
    static func getArtistByAlbum(_ album:Album, context:NSManagedObjectContext) throws -> [Artist]{
        //var artists = [Artist]()
        
        let fetchRequest :NSFetchRequest<Artist> = Artist.fetchRequest()
        
        
        //let format = "ANY albums.name == %@"
        //guard let albumName = album.name else{throw "fucked up" }
        
        //let predicate = NSPredicate(format: format, albumName)
        //fetchRequest.predicate = predicate
        
        let predicate = NSPredicate(format: "album == %@", album)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var artists = [Artist]()
        do{
            artists = try context.fetch(fetchRequest)
            print("artist count for album is\(artists.count)")
        }catch{
            print(error.localizedDescription)
            throw error
        }
        
        return artists
    }
    
    static func getArtistByAlbum(albumMbid:String, context:NSManagedObjectContext) throws -> [Artist]{
        //var artists = [Artist]()
        
        let fetchRequest :NSFetchRequest<Artist> = Artist.fetchRequest()
        
        let format = "ANY albums.mbid == %@"
        
        //guard let albumID = musicBrainz.releases.first?.id else{throw "fucked up" }
        
        let predicate = NSPredicate(format: format, albumMbid)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var artists = [Artist]()
        do{
            artists = try context.fetch(fetchRequest)
            print("artist count for album is\(artists.count)")
        }catch{
            print(error.localizedDescription)
            throw error
        }
        
        return artists
    }
    
    static func getArtistCounts(_ backgroundContext: NSManagedObjectContext) throws -> Int{
        
        let fetchRequest :NSFetchRequest<Artist> = Artist.fetchRequest()
        
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

}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
