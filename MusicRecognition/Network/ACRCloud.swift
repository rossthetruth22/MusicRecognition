//
//  ACRCloud.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/11/21.
//

import Foundation
import CryptoKit


class ACRCloud{
    
    private let apiToken = "e23d42f738edfc001032bef10c7f0104"
    
    static func identify(_ file: URL, completionHandler: @escaping (_ success: Bool, _ response:SongComponents?, _ picURL:String?) -> Void){
        
        let client = NetworkClient()
        let url = "https://identify-us-west-2.acrcloud.com/v1/identify"
        //let url = "https://identify-eu-west-1.acrcloud.com/v1/identify"
        
        let sample = ""
        let accessKey = "0f7f55f5f8be2e118f0c8f3e552dea49"
        //let sampleBytes = 1090
        let timestamp = getTimestamp()
        let dataType = "audio"
        let signatureVersion = 1
        let secretKey = "7mNf7VsNjnnY29tbib5QQorfbowz4z8mrBdodEQo"
        
        let stringToSign = buildStringToSign(method: "POST", uri: "/v1/identify", accessKey: accessKey, dataType: dataType, version: signatureVersion, timestamp: timestamp)
        
        guard let stringData = stringToSign.data(using: .utf8) else {
            print("cant convert string to data")
            return
        }
        guard let secretData = secretKey.data(using: .utf8) else {
            print("cant convert secretKey to data")
            return
        }
        
        var hmac = HMAC<Insecure.SHA1>(key: SymmetricKey(data: secretData))
        hmac.update(data: stringData)
        let encoded = Data(hmac.finalize())
        let base64Encoded = encoded.base64EncodedString()
        
        
        //let testURL = Bundle.main.url(forResource: "testfile", withExtension: "mp3")
        
        var songFile:Data! = nil
        
        do{
            //songFile = try Data(contentsOf: testURL!)
            songFile = try Data(contentsOf: file)

            //print("got the song url")
        }catch{
            print("unable to get test song file")
        }
        
        let sampleBytes = songFile.count
        let request = MultiPartRequest(url: URL(string: url)!)
        
        //request.addFileToBody(fieldName: "sample", data: songFile, fileType: "mp3", mimeType: "audio/mpeg")
        request.addFileToBody(fieldName: "sample", data: songFile, fileType: "m4a", mimeType: "audio/m4a")
        request.addStringToBody(fieldName: "access_key", value: accessKey)
        request.addStringToBody(fieldName: "sample_bytes", value: "\(sampleBytes)")
        request.addStringToBody(fieldName: "timestamp", value: timestamp)
        request.addStringToBody(fieldName: "signature", value: base64Encoded)
        //let signatureString : String = gett
        request.addStringToBody(fieldName: "data_type", value: dataType)
        request.addStringToBody(fieldName: "signature_version", value: "\(signatureVersion)")
        
        
//
//
//        let audDPost = AudDPost(api_token: apiToken, file: songFile, returnVar: parameters)
        
        //commenting for compile. change method signature
        let _ = client.methodForPOST(url, request: request.loadRequest()) { (result, error) in
            guard (error == nil) else {print(error)
                return
            }
            
            guard let result = result else {return}
            
            var acrResponse:ACRResponse? = nil
            do{
                acrResponse = try JSONDecoder().decode(ACRResponse.self, from: result)
            }catch{
                // add actual error here
                print(error)
            }
            
            guard let response = acrResponse else {return}
            
            if response.status.code == 0{
                //sucessful identification
                //sort by score
                let musicCollection = response.metadata!.music
                let sortedMusics = sortACRMusic(musicCollection)
                
                guard let firstMusic = sortedMusics.first else{return}
                
                let albumName = firstMusic.album.name
                let artistCollection = firstMusic.artists.first
                let artistName = artistCollection!.name
                let trackName = firstMusic.title
                
                let isrc = firstMusic.externalIDs?.isrc
                
                let musicBrainz = Musicbrainz()
                
                musicBrainz.getMusicBrainzReleaseACR(trackName, album: albumName, artist: artistName, isrc: isrc ) { components, picURL, error in
                    guard error == nil else{return}
                    
                    guard picURL != nil else{
                        completionHandler(true, components, nil)
                        return
                    }
                    
                    completionHandler(true, components, picURL!)
                }
            }else{
                completionHandler(false,nil,nil)
            }
        }
        
    }
    
    private static func sortACRMusic(_ music:[ACRMusic]) -> [ACRMusic]{
        guard music.count > 1 else {return music}
        
        var hold = music
        
        hold.sort { musicOne, musicTwo in
            
            return ACROrder(musicOne.score).order > ACROrder(musicTwo.score).order
        }
        
        return hold
    }
    
    private static func sortRelease(_ release:[RealMusicbrainzRelease]?, album:String) -> [RealMusicbrainzRelease]?{
        
        guard var releases = release else {return release}
        guard releases.count > 1 else {return release}
        
        print("album is \(album)")
        
        releases.sort { one, two in
            let groupOne = one
            let groupTwo = two
            
            if groupOne.title == album && groupTwo.title == album{
                return ReleaseGroup(groupOne.releaseGroup.primaryType)!.order < ReleaseGroup(groupTwo.releaseGroup.primaryType)!.order
            }else if groupOne.title == album{
                return groupOne.title == album
            }else if groupTwo.title == album{
                return groupTwo.title == album
            }
            
            return groupTwo.title < groupOne.title
        }
        
        return releases
    }
    
    private static func getTimestamp() -> String{
        return String(Date().timeIntervalSince1970)
    }
    
    private static func buildStringToSign(method:String, uri:String, accessKey:String, dataType:String, version:Int, timestamp:String) -> String{
        
//        string_to_sign = http_method+"\n"
//                                    +http_uri+"\n"
//                                    +access_key+"\n"
//                                    +data_type+"\n"
//                                    +signature_version+"\n"
//                                    +timestamp
        var stringToBuild = String()
        stringToBuild += "\(method)\n"
        stringToBuild += "\(uri)\n"
        stringToBuild += "\(accessKey)\n"
        stringToBuild += "\(dataType)\n"
        stringToBuild += "\(version)\n"
        stringToBuild += timestamp
        
        //print(stringToBuild)
        return stringToBuild
    }
    
    init(){
        
    }
}
