//
//  Playlist+CoreDataClass.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/23/21.
//
//

import Foundation
import CoreData

@objc(Playlist)
public class Playlist: NSManagedObject {
    
    static func addPlayList(_ name:String, context:NSManagedObjectContext){
        
        let playlist = Playlist(context: context)
        playlist.name = name
        playlist.creationDate = Date()
    }
    
    static func getPlaylist(_ search:String? = nil, context:NSManagedObjectContext) throws -> [Playlist]{
        
        var playlists = [Playlist]()
        
        let fetchRequest :NSFetchRequest<Playlist> = Playlist.fetchRequest()
        
        if let search = search{
            let format = "name LIKE[c] %@"
            let predicate = NSPredicate(format: format, "*\(search)*")
            fetchRequest.predicate = predicate
        }
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        do{
            playlists = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
            throw error
        }
        
        return playlists
        
    }
    
    static func checkIfPlaylistExists(_ name:String, context:NSManagedObjectContext) -> Bool{
        
        let fetchRequest :NSFetchRequest<Playlist> = Playlist.fetchRequest()
      
        let format = "name MATCHES[c] %@"
        let predicate = NSPredicate(format: format, "\(name)")
        fetchRequest.predicate = predicate
        
        var count = 0
        do{
           count = try context.count(for: fetchRequest)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
            //throw CoreDataError.couldNotFetch
        }
        return count == 0 ? true : false
        
    }
    
    static func addPlaylistSongs(){
        
    }

}
