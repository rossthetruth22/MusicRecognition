//
//  Album+CoreDataClass.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/4/21.
//
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject {
    
    static func addAlbum(_ song:AudDSong, context: NSManagedObjectContext) -> Album{
        
        let album = Album(context: context)
        album.name = song.album
        album.mbid = song.musicbrainz?.first?.releases.first?.id
        
        return album
    }
    
//    static func addAlbum(response:AudDResponse, context: NSManagedObjectContext) -> Album{
//
//        let album = Album(context: context)
//        album.name = response.result.album
//        album.mbid = response.musicbrainz.releases.first?.id
//
//        return album
//    }
    
    static func fetchAlbums(_ search: String? = nil, context: NSManagedObjectContext) throws -> [Album]{
        
        
        var albums = [Album]()
        
        let fetchRequest :NSFetchRequest<Album> = Album.fetchRequest()
        
        if let search = search{
            let format = "name LIKE[c] %@"
            let predicate = NSPredicate(format: format, "*\(search)*")
            fetchRequest.predicate = predicate
        }
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]

        do{
            albums = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
            throw error
        }
        return albums
    }
    
    static func fetchAlbums(_ search:String? = nil, albumMbid:String?, context:NSManagedObjectContext) throws -> [Album]{
        
        var albums = [Album]()
        
        let fetchRequest :NSFetchRequest<Album> = Album.fetchRequest()
        
        var predicates = [NSPredicate]()
        
        if let albumMbid = albumMbid{
            let format = "mbid MATCHES %@"
            let predicate = NSPredicate(format: format, albumMbid)
            predicates.append(predicate)
        }
        
        if let search = search{
            let format = "name LIKE[c] %@"
            let predicate = NSPredicate(format: format, "*\(search)*")
            predicates.append(predicate)
            //fetchRequest.predicate = predicate
            
        }
        
        if predicates.count > 1{
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }else if predicates.count == 1{
            fetchRequest.predicate = predicates.first!
        }
        
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        do{
            albums = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
            throw error
        }
        return albums
        
    }
    
    static func fetchAlbums(albumMbid:String, context: NSManagedObjectContext) throws ->[Album]{
        
        var albums = [Album]()
        
        let fetchRequest :NSFetchRequest<Album> = Album.fetchRequest()
        
        let format = "mbid MATCHES %@"
        let predicate = NSPredicate(format: format, albumMbid)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        

        do{
            albums = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
            throw error
        }
        return albums
        
    }
    
    
    
    static func getAlbumCounts(_ backgroundContext: NSManagedObjectContext) throws -> Int{
        
        let fetchRequest :NSFetchRequest<Album> = Album.fetchRequest()
        
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
    
    static func fetchArtistAlbums(_ artist:Artist, context:NSManagedObjectContext) throws -> [Album]{
            
        let fetchRequest : NSFetchRequest<Album> = Album.fetchRequest()
        let predicate = NSPredicate(format: "artist == %@", artist)
        fetchRequest.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        var albums = [Album]()
        do {
            albums = try context.fetch(fetchRequest)
        }catch{
            
        }
        return albums
    }

}
