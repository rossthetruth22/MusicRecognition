//
//  ACRCloud.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/11/21.
//

import Foundation

class ACRCloud{
    
    private let apiToken = "e23d42f738edfc001032bef10c7f0104"
    
    static func identify(){
        
        let client = NetworkClient()
        let url = "https://identify-eu-west-1.acrcloud.com/v1/identify"
        let parameters = "lyrics,apple_music,spotify"
        let accessKey = ""
        
        let testURL = Bundle.main.url(forResource: "testfile", withExtension: "mp3")
        
        var songFile:Data! = nil
        
        do{
            songFile = try Data(contentsOf: testURL!)
            //print("got the song url")
        }catch{
            print("unable to get test song file")
        }
        
        
//        let request = MultiPartRequest(url: URL(string: url)!)
//        request.addStringToBody(fieldName: "return", value: parameters)
//        request.addStringToBody(fieldName: "api_token", value: apiToken)
//        request.addFileToBody(fieldName: "file", data: songFile, fileType: "mp3", mimeType: "audio/mpeg")
//
//
//        let audDPost = AudDPost(api_token: apiToken, file: songFile, returnVar: parameters)
        
        
//        client.methodForPOST(url, request: request.loadRequest()) { (result, error) in
//            guard (error == nil) else {print(error)
//                return
//            }
//            
//            guard let result = result else {return}
//            
//            print(result)
//        }
//        client.methodForPOST(url, songFile, formData: callData) { (data, error) in
//            guard (error == nil) else {print(error)
//                return}
//
//            guard let data = data else {return}
//
//           print(data)
//        }
    }
    
}
