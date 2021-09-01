//
//  Musicbrainz.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/6/21.
//

import Foundation

class Musicbrainz{
    
    
    private let client = NetworkClient.shared
    
    func getPictureURL(_ mbid:String, completionHandler: @escaping (_ small:String?, _ large: String?, _ error: Error?) -> Void) {
        
        
        
        let httpURL = HTTPURL("https", "coverartarchive.org", "/release-group/\(mbid)", nil, [:])
        //let url = "https://coverartarchive.org"
 
        print("http url is :\(httpURL)")
        let _ = client.methodForGET(httpURL) { result, error in
            
            guard (error == nil) else {print(error)
                return
            }
            
            guard let result = result else {
                completionHandler(nil,nil,nil)
                return}
            
    //TODO: Convert to struct and get the imageURL from it
            var formattedResult:CoverArt? = nil
            do{
                formattedResult = try JSONDecoder().decode(CoverArt.self, from: result)
            }catch{
                completionHandler(nil,nil,error)
                print(error)
            }
            
            //print(formattedResult)
            //completionHandler(formattedResult!.images.first?.image, nil)
            completionHandler(formattedResult!.images.first?.thumbnails.sizeSmall ,formattedResult!.images.first?.thumbnails.sizeLarge, nil)
        }
                
    }
    
    
    func getMusicBrainzRelease(_ song: AudDSong, completionForRelease: @escaping (_ releaseRecording:RealMusicbrainzRecording?, _ error:Error?) -> Void){
        
        
        // https://musicbrainz.org/ws/2/recording?query=(recording:%22Deep%20Down%20Body%20Thurst%22%20AND%20release:%22NO%20ONE%20EVER%20REALLY%20DIES%22)%20OR%20(recording:%22Deep%20Down%20Body%20Thurst%22%20AND%20release:%22NO%20ONE%20EVER%20REALLY%20DIES%22%20AND%20(artist:%22N.E.R.D%22%20OR%20artistname:%22N.E.R.D%22))
        let escapedArtist = escapeToLucene(song.artist)
        let escapedRecording = escapeToLucene(song.title)
        let escapedRelease = escapeToLucene(song.album)
        
        let and = " AND"
        let or = " OR"
        let artist = "artist:\"\(escapedArtist)\""
        let artistName = "artistname:\"\(escapedArtist)\""
        let recording = "recording:\"\(escapedRecording)\""
        let release = "release:\"\(escapedRelease)\""
        let alias = "alias:\"\(escapedRecording)\""
        
        let callStringOne = "((\(recording)\(or) \(alias))\(and) \(release)) "
        //let callStringOne = "(\(recording)\(and) \(release))"
        let callStringTwo = "((\(recording)\(or) \(alias))\(and) \(release)\(and) (\(artist)\(or) \(artistName)))"
        //let callStringTwo = "(\(recording)\(and) \(release)\(and) (\(artist)\(or) \(artistName)))"
        let callString = "\(callStringOne)\(or) \(callStringTwo)"
        
        let queryItems = ["query":callString, "fmt":"json"] as [String:AnyObject]
        
        let httpURL = HTTPURL("https", "musicbrainz.org", "/ws/2/", "recording", queryItems)
        
        let _ = client.methodForGET(httpURL) { result, error in
            guard (error == nil) else {print(error)
                return
            }
            
            guard let result = result else {
                completionForRelease(nil,error)
                return}
            
    //TODO: Convert to struct and get the imageURL from it
            var formattedResult:RealMusicbrainz? = nil
            do{
                formattedResult = try JSONDecoder().decode(RealMusicbrainz.self, from: result)
            }catch{
                completionForRelease(nil,error)
                print(error)
            }
            
            let recordings = formattedResult?.recordings?.sorted(by: { recordingOne, recordingTwo in
                
                if let cleanOne = recordingOne.disambiguation{
                    if let cleanTwo = recordingTwo.disambiguation{
                        if cleanOne.contains("clean") && cleanTwo.contains("clean"){
                            return recordingOne.score > recordingTwo.score
                        }
                    }else if cleanOne.contains("clean"){
                        return recordingTwo.score < recordingOne.score
                    }
                }
                return recordingOne.score > recordingTwo.score
            })
            
            if let realrecordings = recordings{
                completionForRelease(realrecordings.first!, nil)
            }else{
                //some error
                completionForRelease(nil,nil)
                print("houston we have a problem")
            }
            //print(recordings)
            //print(formattedResult)
            
            //completionForRelease(recordings.first!, nil)
        }
        
        
    }
    
    func getMusicBrainzReleaseACR(_ title:String, album:String, artist:String, isrc:String?, completionForRelease: @escaping (_ releaseRecording:SongComponents?, _ picURL:String?, _ error:Error?) -> Void){
        
        
        // https://musicbrainz.org/ws/2/recording?query=(recording:%22Deep%20Down%20Body%20Thurst%22%20AND%20release:%22NO%20ONE%20EVER%20REALLY%20DIES%22)%20OR%20(recording:%22Deep%20Down%20Body%20Thurst%22%20AND%20release:%22NO%20ONE%20EVER%20REALLY%20DIES%22%20AND%20(artist:%22N.E.R.D%22%20OR%20artistname:%22N.E.R.D%22))
        let escapedArtist = escapeToLucene(artist)
        let escapedRecording = escapeToLucene(title)
        let escapedRelease = escapeToLucene(album)
        
        let theISRC = isrc
        
        //let callStringOne = "((\(recording)\(or) \(alias))\(and) \(release)) "
        //let callStringOne = "(\(recording)\(and) \(release))"
//        let callStringTwo = "((\(recording)\(or) \(alias))\(and) \(release)\(and) (\(artist)\(or) \(artistName)))"
        //let callStringTwo = "(\(recording)\(and) \(release)\(and) (\(artist)\(or) \(artistName)))"
        
        let and = " AND"
        let or = " OR"
        let artistOnly = "artist:\"\(escapedArtist)\""
        let artistName = "artistname:\"\(escapedArtist)\""
        let recording = "recording:\"\(escapedRecording)\""
        let release = "release:\"\(escapedRelease)\""
        let alias = "alias:\"\(escapedRecording)\""
        var isrcString:String! = nil
        if theISRC != nil{
            isrcString = "isrc:\"\(theISRC!)\""
        }
        
    
        
        let callStringOne = "(\(recording)\(and) \(release))"
        let callStringTwo = "(\(recording)\(and) \(release)\(and) (\(artistOnly)\(or) \(artistName)))"
        let callStringThree = "(\(recording)\(and) (\(artistOnly)\(or) \(artistName)))"
        var callString:String! = nil
        
        if isrcString != nil{
            callString = "\(isrcString!)\(or) \(callStringOne)\(or) \(callStringTwo)\(or) \(callStringThree)"
        }else{
            callString = "\(callStringOne)\(or) \(callStringTwo)\(or) \(callStringThree)"
        }
        //let callString = "\(callStringOne)\(or) \(callStringTwo)\(or) \(callStringThree)"
        
        let queryItems = ["query":callString, "fmt":"json"] as [String:AnyObject]
        
        let httpURL = HTTPURL("https", "musicbrainz.org", "/ws/2/", "recording", queryItems)
        
        let _ = client.methodForGET(httpURL) { result, error in
            guard (error == nil) else {print(error)
                return
            }
            
            guard let result = result else {
                completionForRelease(nil, nil, error)
                return}
            
    //TODO: Convert to struct and get the imageURL from it
            var formattedResult:RealMusicbrainz? = nil
            do{
                formattedResult = try JSONDecoder().decode(RealMusicbrainz.self, from: result)
            }catch{
                completionForRelease(nil,nil,error)
                print(error)
            }
            
            let recordings = formattedResult?.recordings?.sorted(by: { recordingOne, recordingTwo in
                
                if let cleanOne = recordingOne.disambiguation{
                    if let cleanTwo = recordingTwo.disambiguation{
                        if cleanOne.contains("clean") && cleanTwo.contains("clean"){
                            return recordingOne.score > recordingTwo.score
                        }
                    }else if cleanOne.contains("clean"){
                        return recordingTwo.score < recordingOne.score
                    }
                }
                return recordingOne.score > recordingTwo.score
            })
            
            let sharedCatalogContext = CatalogData.shared.backgroundContext
            let newSong = Song(context: sharedCatalogContext)
            let newAlbum = Album(context: sharedCatalogContext)
            let newArtist = Artist(context: sharedCatalogContext)
            let songComponents = SongComponents(newSong, newArtist, newAlbum)
            songComponents.song.name = title
            songComponents.album.name = album
            songComponents.artist.name = artist
            songComponents.song.artistName = artist
            print("artist nigga \(artist)")
            songComponents.song.albumName = album
            
//            newArtist.name = artist
//            newAlbum.name = album
//            newSong.name = title
            
            // if no recording, try to search by release group only. Will not use song mbid
            
            //if let realrecordings = recordings{
            if let realrecordings = recordings, realrecordings.count > 0{
                //nil here? Under pressure by logic
                // UnderPressure remix by CPTime/Cole Parkinson
                
                
                
                let firstRecording = realrecordings.first!
                songComponents.song.mbid = firstRecording.id
                let firstArtist = firstRecording.artistCredit?.first!
                songComponents.artist.mbid = firstArtist?.artist.id
                songComponents.song.length = Int32(firstRecording.length!)
                
                //newSong.mbid = firstRecording.id
                //newSong.duration
               
                guard let releases = self.sortRelease(firstRecording.releases, album: album, song: firstRecording.title) else {
                        print("another problem")
                        return
                    }
                for release in releases{
                    print("/n")
                    print(release)
                    print("/n")
                }
                guard let mbid = releases.first?.releaseGroup.id else {
                    //completionHandler(true, song, nil)
                    return}
                songComponents.album.mbid = mbid
                
                
                //newAlbum.mbid = mbid
                self.getPictureURL(mbid) { smallPicURL, picURL, error in
                    
                    guard error == nil else{
                        completionForRelease(songComponents, nil, error)
                        return}
                    guard picURL != nil else{
                        completionForRelease(songComponents, nil, error)
                        return}
                    let newUrl = picURL?.replacingOccurrences(of: "http:", with: "https:")
                    let smallURL = smallPicURL?.replacingOccurrences(of: "http:", with: "https:")

                    songComponents.album.imageURL = newUrl
                    let _ = PictureFetch(smallURL).image
                    
                    songComponents.album.smallImageURL = smallURL
                    
                    completionForRelease(songComponents,newUrl!,nil)
                }
                //completionForRelease(songComponents, nil)
                //completionForRelease(realrecordings.first!, nil)
                
            }else{
                //No musicbrainz
                
                self.tryReleaseOnly(album: album, artist: artist) { reult, pic, error in
                    //
                }
            
                completionForRelease(songComponents,nil,nil)
                //completionForRelease(nil,nil)
                print("houston we have a problem")
            }
        }
        
        
    }
    
    private func tryReleaseOnly(album:String, artist:String, completionForRelease: @escaping (_ releaseRecording:SongComponents?, _ picURL:String?, _ error:Error?) -> Void){
        
        let escapedArtist = escapeToLucene(artist)
        let escapedRelease = escapeToLucene(album)
        
        let and = " AND"
        let or = " OR"
        let artistOnly = "artist:\"\(escapedArtist)\""
        let artistName = "artistname:\"\(escapedArtist)\""
        let release = "release:\"\(escapedRelease)\""
        
        let callString = "(\(release)\(and) (\(artistOnly)\(or) \(artistName)))"
        
        let queryItems = ["query":callString, "fmt":"json"] as [String:AnyObject]
        
        let httpURL = HTTPURL("https", "musicbrainz.org", "/ws/2/", "release-group", queryItems)
        
        let _ = client.methodForGET(httpURL) { result, error in
            //
        }
        
    }
    private func sortRelease(_ release:[RealMusicbrainzRelease]?, album:String, song:String) -> [RealMusicbrainzRelease]?{
        
        guard var releases = release else {return release}
        guard releases.count > 1 else {return release}
        
        print("album is \(album)")
        
        releases.sort { one, two in
            let groupOne = one
            let groupTwo = two
            
            //true when the first should come before the second
            //sort by title and primary type.
            //if primary type is album and title matches
            //if primary type is single and title matches
            //albums, sinngles
            //rest of the types in
            
            //take single into account
            
            //take date into account
   
            if groupOne.title == album && groupTwo.title == album{
                
                if groupOne.date != nil && groupTwo.date != nil{
                    return groupOne.date! < groupTwo.date!
                }
                return ReleaseGroup(groupOne.releaseGroup.primaryType)!.order < ReleaseGroup(groupTwo.releaseGroup.primaryType)!.order
                
            }else if groupOne.title == album || groupTwo.title == album{
                return groupOne.title == album
            }else if groupOne.title == song || groupTwo.title == song{
                return groupOne.title == song
            }else if groupOne.releaseGroup.primaryType != nil && groupTwo.releaseGroup.primaryType != nil{
                return ReleaseGroup(groupOne.releaseGroup.primaryType)!.order < ReleaseGroup(groupTwo.releaseGroup.primaryType)!.order
            }
            
            //return groupTwo.title < groupOne.title
            return groupOne.title < groupTwo.title
        }
        
        return releases
    }
    
    private func escapeToLucene(_ toEscape:String) -> String{
        
        let specialCharacters = ["+", "-", "&&", "||", "!", "(", ")", "{", "}", "[","]", "^", "\"", "~", "*", "?", ":", "\\", "/"]
        
        let slash = "\\"
        var newString = toEscape
        for literal in specialCharacters{
            newString = newString.replacingOccurrences(of: literal, with: "\(slash)\(literal)")
        }
        
        return newString
    }
    
    
}
