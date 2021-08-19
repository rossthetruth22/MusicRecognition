//
//  Musicbrainz.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/6/21.
//

import Foundation

class Musicbrainz{
    
    
    private let client = NetworkClient.shared
    
    func getPictureURL(_ mbid:String, completionHandler: @escaping (_ imageURL: String?, _ error: Error?) -> Void) {
        
        
        
        let httpURL = HTTPURL("https", "coverartarchive.org", "/release-group/\(mbid)", nil, [:])
        //let url = "https://coverartarchive.org"
 
        print("http url is :\(httpURL)")
        let _ = client.methodForGET(httpURL) { result, error in
            
            guard (error == nil) else {print(error)
                return
            }
            
            guard let result = result else {
                completionHandler(nil,nil)
                return}
            
    //TODO: Convert to struct and get the imageURL from it
            var formattedResult:CoverArt? = nil
            do{
                formattedResult = try JSONDecoder().decode(CoverArt.self, from: result)
            }catch{
                completionHandler(nil,error)
                print(error)
            }
            
            //print(formattedResult)
            
            completionHandler(formattedResult!.images.first?.image, nil)
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
        
        let callStringOne = "(\(recording)\(and) \(release))"
        let callStringTwo = "(\(recording)\(and) \(release)\(and) (\(artist)\(or) \(artistName)))"
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
    
    func getMusicBrainzReleaseACR(_ title:String, album:String, artist:String, completionForRelease: @escaping (_ releaseRecording:RealMusicbrainzRecording?, _ error:Error?) -> Void){
        
        
        // https://musicbrainz.org/ws/2/recording?query=(recording:%22Deep%20Down%20Body%20Thurst%22%20AND%20release:%22NO%20ONE%20EVER%20REALLY%20DIES%22)%20OR%20(recording:%22Deep%20Down%20Body%20Thurst%22%20AND%20release:%22NO%20ONE%20EVER%20REALLY%20DIES%22%20AND%20(artist:%22N.E.R.D%22%20OR%20artistname:%22N.E.R.D%22))
        let escapedArtist = escapeToLucene(artist)
        let escapedRecording = escapeToLucene(title)
        let escapedRelease = escapeToLucene(album)
        
        let and = " AND"
        let or = " OR"
        let artist = "artist:\"\(escapedArtist)\""
        let artistName = "artistname:\"\(escapedArtist)\""
        let recording = "recording:\"\(escapedRecording)\""
        let release = "release:\"\(escapedRelease)\""
        
        let callStringOne = "(\(recording)\(and) \(release))"
        let callStringTwo = "(\(recording)\(and) \(release)\(and) (\(artist)\(or) \(artistName)))"
        let callStringThree = "(\(recording)\(and) (\(artist)\(or) \(artistName)))"
        let callString = "\(callStringOne)\(or) \(callStringTwo)\(or) \(callStringThree)"
        
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
                //nil here? Under pressure by logic
                // UnderPressure remix by CPTime/Cole Parkinson
                print(realrecordings)
                completionForRelease(realrecordings.first!, nil)
                //no musicbrainz?
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
