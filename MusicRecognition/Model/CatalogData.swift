//
//  CurrencyData.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 10/18/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation
import CoreData

class CatalogData:NSPersistentContainer{

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.newBackgroundContext()
        return context
    }()
    
    private var modelName:String
    //private var countries = [Country]()
    //private var currencies = [Currency]()
    static let shared = CatalogData(name: "MusicRecognition")
    
    func createSong(songComponents: SongComponents) throws -> Void{
        
        //check if song exists
        if getSongCount(songComponents.song.name, mbid: songComponents.song.mbid) >= 1{
            //throw some error
            return
        }
//        if getSongCount(song.musicbrainz?.first?.id) >= 1{
//            //throw some error
//            return
//        }
        
        let newAlbum = songComponents.album
        let newSong = songComponents.song
        newSong.timestamp = Date()
        let newArtist = songComponents.artist
        
        //var album = Album(context: backgroundContext)
        //var artist = Artist(context: backgroundContext)
        //var album:Album! = nil
        //var artist:Artist! = nil
        
        do{
            print("trying to fetch an existing album for song \(newSong.name)")
            //let albumsFetched = try Album.fetchAlbums(songToSave.album, context: context)
            let albumsFetched = try Album.fetchAlbums(newAlbum.name, albumMbid: newAlbum.mbid, context: viewContext)
            //let albumsFetched = try Album.fetchAlbums(albumMbid: (musicBrainz?.first!.releases.first!.id)!, context: context)
            if albumsFetched.count >= 1{
                let fetched = albumsFetched.first
                guard let objectID = fetched?.objectID else {return}
                let theAlbum =  try backgroundContext.existingObject(with: objectID) as! Album
                newSong.album = theAlbum
                newSong.albumName = theAlbum.name
                backgroundContext.delete(newAlbum)
                //album = theAlbum
                print("album is \(theAlbum.name)")
                
                //if you get an album, just grab the artist from the album
                newSong.artist = newSong.album?.artist
                newSong.artistName = newSong.album?.artist?.name
                backgroundContext.delete(newArtist)
                //artist = album.artist!
                //??
                print("artist for album is \(newSong.artist?.name)")
                

            }else{
                print("no album found with this name.")
                //album = Album.addAlbum(songToSave, context: context)
                
                newSong.album = newAlbum
                newSong.albumName = newAlbum.name
                //album = newAlbum
                
                //album = Album.addAlbum(songToSave, context: context)
                //check if existing artist
                do{
                    var artists = [Artist]()
                    //artists = try Artist.getArtist(songToSave.artist, context: context)
                    //artists = try Artist.getArtist(musicBrainz?.first?.artistCredit.first?.artist.id, context: context)
                    artists = try Artist.getArtist(newArtist.name, artistMbid: newArtist.mbid, context: viewContext)
                    if artists.count >= 1{
                        let fetched = artists.first
                        guard let objectID = fetched?.objectID else {return}
                        let theArtist =  try backgroundContext.existingObject(with: objectID) as! Artist
                        newSong.artist = theArtist
                        newSong.album?.artist = theArtist
                        newSong.artistName = theArtist.name
                        backgroundContext.delete(newArtist)
                        //artist = theArtist
                        //artist = artists.first
                    }else{
                        //artist = Artist.addArtist(songToSave, context: context)
                        //artist = Artist.addArtist(songToSave, context: context)
                        newSong.artist = newArtist
                        newSong.album?.artist = newArtist
                        newSong.artistName = newArtist.name
                        //artist = newArtist
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                //album.artist = artist
            }
        }catch{
            print("Problem with album fetch")
        }
        
        //newSong.artist = artist
        //newSong.album = album
        
        //newSong.albumName = album.name
        //newSong.artistName = artist.name
        
        
        //Song.addSong(songComponents, context: backgroundContext)
        
        do {
            try saveContext(backgroundContext: backgroundContext)
        }catch{
            print("Couldn't save songs")
            throw error
        }
        
        getSongCount()
        getArtistCount()
        getAlbumCount()

    }
    
    func createPlaylist(name:String) -> Bool{
        
        if !Playlist.checkIfPlaylistExists(name, context: viewContext){
            return false
        }
        
        Playlist.addPlayList(name, context: backgroundContext)
        do{
            try saveContext(backgroundContext: backgroundContext)
        }catch{
            return false
        }
        
        return true
        
    }
    
//    func createSong(response: AudDResponse) throws -> Void{
//        
//        //check if song exists
//        if getSongCount(response.musicbrainz.id) >= 1{
//            return
//        }
//        
//        Song.addSong(response, context: backgroundContext)
//        //Song.addSong(song, context: backgroundContext)
//        
//        do {
//            try saveContext(backgroundContext: backgroundContext)
//        }catch{
//            print("Couldn't save songs")
//            throw error
//        }
//        
//        getSongCount()
//        getArtistCount()
//        getAlbumCount()
//    }
    
    func getSongCount(_ search:String? = nil) -> Int{
        
        var count = 0
        do{
            count = try Song.getSongCounts(search, backgroundContext: viewContext)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
        }
        
//        let fetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
//        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptors]
//
//        var count = 0
//
//        do{
//           count = try backgroundContext.count(for: fetchRequest)
//        }catch{
//            let error = error as NSError
//            print(error.localizedDescription)
//            //throw CoreDataError.couldNotFetch
//        }
        
        print("Song count is: \(count)")
        return count
        
    }
    
    func getSongCount(_ search:String?, mbid:String?) -> Int{
        var count = 0
        do{
            count = try Song.getSongCounts(search, songMbid: mbid, context: viewContext)
            //count = try Song.getSongCounts(mbid, backgroundContext: backgroundContext)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
        }
        
        return count
    }
    
    func getAlbumCount(){
        let fetchRequest : NSFetchRequest<Album> = Album.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var count = 0
        
        do{
           count = try viewContext.count(for: fetchRequest)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
            //throw CoreDataError.couldNotFetch
        }
        
        print("Album count is: \(count)")
    }
    
    private func getArtistCount(){
        
        let fetchRequest : NSFetchRequest<Artist> = Artist.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var count = 0
        
        do{
           count = try viewContext.count(for: fetchRequest)
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
            //throw CoreDataError.couldNotFetch
        }
        
        print("Artist count is: \(count)")
        
    }
    
    func getSongs(_ search:String? = nil) throws -> [Song]{

        var songs = [Song]()
        do{
            songs = try Song.fetchSongs(context: viewContext)
        }catch{
            print(error.localizedDescription)
            throw error
            
        }
        
        return songs
    }
    
    func getAlbums(_ search:String? = nil) throws -> [Album]{

        var albums = [Album]()
        do{
            albums = try Album.fetchAlbums(context: viewContext)
        }catch{
            print(error.localizedDescription)
            throw error
            
        }
        
        return albums
    }
    
    func getAlbumSongs(_ album:Album) throws -> [Song]{
        
        var songs = [Song]()        
        do{
            songs = try Song.fetchAlbumSongs(album, context: viewContext)
        }catch{
            
        }
        return songs
    }
    
    func getAllArtists() throws -> [Artist]{
        
        var artists = [Artist]()
        do{
            artists = try Artist.getArtist(context: viewContext)
        }catch{
            print(error.localizedDescription)
            throw error
            
        }
        return artists
    }
    
    func getAllArtistSongs(_ artist:Artist) throws -> [Song]{
        var songs = [Song]()
        do{
            songs = try Song.fetchArtistSongs(artist, context: viewContext)
        }catch{
            
        }
        return songs
    }
    
    func getAllPlaylists() throws -> [Playlist]{
        var playlists = [Playlist]()
        do{
            playlists = try Playlist.getPlaylist(context: viewContext)
        }catch{
            
        }
        return playlists
    }
    
    func getAllSongsForPlaylist(_ playlist:Playlist) throws -> [Song]{
        var songs = [Song]()
        do{
            songs = try Song.fetchPlaylistSongs(playlist, context: viewContext)
        }catch{
            
        }
        return songs
    }
    
    
    func getAllAlbumsForArtist(_ artist:Artist) throws -> [Album] {
        var albums = [Album]()
        do{
            albums = try Album.fetchArtistAlbums(artist, context: viewContext)
        }catch{
            
        }
        return albums
    }
    
    func addSongsToPlaylist(_ songs:NSSet, _ playlist:Playlist){
        
        playlist.addToSongs(songs)
        do{
            try saveContext()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func removeSongsFromFromPlaylist(_ songs:NSSet, _ playlist:Playlist){
        playlist.removeFromSongs(songs)
        do{
            try saveContext()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func clearContext(){
        if backgroundContext.hasChanges{
            backgroundContext.rollback()
        }
    }
    
//    func fetchCurrencies(_ searchString: String? = nil) throws -> [Currency]{
//        let fetchRequest : NSFetchRequest<Currency> = Currency.fetchRequest()
//        let sortDescriptors = NSSortDescriptor(key: "currencyCode", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptors]
//        if let search = searchString{
//            //let args = [""]
//            //let format = "(currencyCode LIKE[c] %@) OR (currencyName LIKE[c] %@)"
//            let formatOne = "currencyCode LIKE[c] %@"
//            let formatTwo = "currencyName LIKE[c] %@"
//
////            let predicateOne = fetchRequest.predicate = NSPredicate(format: format, "*\(search)*")
//            let predicateOne = NSPredicate(format: formatOne, "*\(search)*")
//            let predicateTwo = NSPredicate(format: formatTwo, "*\(search)*")
//            let predArr = [predicateOne, predicateTwo]
//            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predArr)
//            fetchRequest.predicate = compoundPredicate
//
//        }
//        var current = [Currency]()
//        do{
//            current = try viewContext.fetch(fetchRequest)
//        }catch{
//            //let error = error as NSError
//            //print(error.localizedDescription)
//            throw CoreDataError.couldNotFetch
//
//        }
//
//        return current
//
//    }

    
    
    func checkEntityCountAndDelete<T: NSManagedObject>(entity: T.Type) throws -> Void{
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        var count = 0
        
        do{
           count = try backgroundContext.count(for: fetchRequest)
        }catch{
            //let error = error as NSError
            //print(error.localizedDescription)
            //throw CoreDataError.couldNotFetch
        }
        
        //print("count of \(T.Type.self) is \(count)")
        if count > 0 {
            let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do{
                try backgroundContext.execute(batchRequest)
            }catch{
                let error = error as NSError
                print(error.localizedDescription)
                //throw CoreDataError.couldNotSave
            }
        }
        
    }
    
    
    
    func saveContext (backgroundContext: NSManagedObjectContext? = nil) throws -> Void {
        let context = backgroundContext ?? self.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("unsuccessful")
                //let nserror = error as NSError
                //throw CoreDataError.couldNotSave
                //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                print(error.localizedDescription)
            }
        }
    }
    
    
    private init(name: String) {
        self.modelName = name
        guard let modelURL = Bundle.main.url(forResource: "MusicRecognition",
                                             withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        super.init(name: self.modelName, managedObjectModel: mom)
        
        self.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        viewContext.automaticallyMergesChangesFromParent = true
    }



}
