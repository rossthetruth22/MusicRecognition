//
//  AudD.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/7/21.
//

import Foundation


class AudD{
    
    private let apiToken = "e23d42f738edfc001032bef10c7f0104"
    
    static func recognize(file:URL, completionHandler: @escaping (_ success: Bool, _ response:AudDSong?) -> Void){
        
        let client = NetworkClient()
        let url = "https://api.audd.io/"
        let parameters = "lyrics,apple_music,spotify"
        let apiToken = "e23d42f738edfc001032bef10c7f0104"
        
        //let testURL = Bundle.main.url(forResource: "testfile", withExtension: "mp3")

        var songFile:Data! = nil
        
        do{
            //songFile = try Data(contentsOf: testURL!)
            songFile = try Data(contentsOf: file)
        }catch{
            print("unable to get test song file")
        }
        
        
        let request = MultiPartRequest(url: URL(string: url)!)
        request.addStringToBody(fieldName: "api_token", value: apiToken)
        request.addStringToBody(fieldName: "return", value: parameters)
        //request.addFileToBody(fieldName: "file", data: songFile, fileType: "mp3", mimeType: "audio/mpeg")
        request.addFileToBody(fieldName: "file", data: songFile, fileType: "m4a", mimeType: "audio/m4a")
        
        
        
        //let audDPost = AudDPost(api_token: apiToken, file: songFile, returnVar: parameters)
 
//        var callData:Data!
//
//        do{
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//
//            callData = try encoder.encode(audDPost)
//        }catch{
//            print(error)
//        }
        
        
        client.methodForPOST(url, request: request.loadRequest()) { (result, error) in
            guard (error == nil) else {print(error)
                return
            }
            
            guard let result = result else {
                completionHandler(false,nil)
                return}
            
            var formattedResult:AudDResponse? = nil
            do{
                formattedResult = try JSONDecoder().decode(AudDResponse.self, from: result)
            }catch{
                completionHandler(false,nil)
                print(error)
            }
//            let formattedResult = try? JSONDecoder().decode([AudDObject].self, from: result)
    
            completionHandler(true, formattedResult?.result)
            //print(result)
        }
    }
}
