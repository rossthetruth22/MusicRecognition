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
    
    static func addPlayList(){
        
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

}
