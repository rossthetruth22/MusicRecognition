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
    
    func createSong(song: AudDSong) throws -> Void{
        
        //check if song exists
        if getSongCount(song.title) >= 1{
            return
        }
        
        
        Song.addSong(song, context: backgroundContext)
        
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
    
    func getSongCount(_ search:String? = nil) -> Int{
        
        var count = 0
        do{
            count = try Song.getSongCounts(search, backgroundContext: backgroundContext)
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
    
    func getAlbumCount(){
        let fetchRequest : NSFetchRequest<Album> = Album.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var count = 0
        
        do{
           count = try backgroundContext.count(for: fetchRequest)
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
           count = try backgroundContext.count(for: fetchRequest)
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
    
    func createCurrencies(currencyDict: [String:[String:AnyObject]]) throws -> Void{
        
        do {
           // checkEntityCountAndDelete(entity: Currency.self)
        }catch{
            throw error
        }
        //checkEntityCountAndDelete(entity: Currency.self)
        
        for (_, currency) in currencyDict{
            //Currency.addCurrency(currency, context: self.backgroundContext)
        }
        
//        guard let currencies = Array(backgroundContext.insertedObjects) as? [Currency] else{
//            print("unsuccessful")
//            return
//        }
  
//        do {
//           try fetchCountries()
//        }catch{
//            throw error
//        }
        //fetchCountries()
//        let countryDict = Country.createCountryDict(countries: countries)
//        Currency.addFlag(countries: countryDict, currencies: currencies, context: backgroundContext)
        
        do {
            try saveContext(backgroundContext: backgroundContext)
        }catch{
            throw error
        }
        //saveContext(backgroundContext: backgroundContext)
        
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
    
    func createCountries(countryDict: [String:[String:AnyObject]]) throws -> Void {
        
        do{
            //try checkEntityCountAndDelete(entity: Country.self)
        }catch{
            throw error
        }
        
        //checkEntityCountAndDelete(entity: Country.self)
        for (_, country) in countryDict{
            //Country.addCountry(country, context: self.backgroundContext)
        }
        
        do {
            try saveContext(backgroundContext: backgroundContext)
        }catch{
            throw error
        }
        
        //Country.createCountryDict(countries: fetchCountries())
    }
    
//    func fetchCountries() throws -> Void{
//        let fetchRequest : NSFetchRequest<Country> = Country.fetchRequest()
//        var countries = [Country]()
//        do{
//            countries = try backgroundContext.fetch(fetchRequest)
//        }catch{
//            //let error = error as NSError
//            //print(error.localizedDescription)
//            throw CoreDataError.couldNotFetch
//
//        }
//        self.countries = countries
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
    }



}
