//
//  Musicbrainz.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/6/21.
//

import Foundation

class Musicbrainz{
    
    static func getPictureURL(_ mbid:String, completionHandler: @escaping (_ imageURL: String?, _ error: Error?) -> Void) {
        
        let client = NetworkClient.shared
        
        let httpURL = HTTPURL("https", "coverartarchive.org", "/release-group/\(mbid)", [:])
        //let url = "https://coverartarchive.org"
 
        
        let _ = client.methodForGET(nil, httpURL: httpURL) { result, error in
            
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
    
}
