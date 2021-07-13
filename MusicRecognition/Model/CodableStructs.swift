//
//  CodableStructs.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/11/21.
//

import Foundation

struct AudDPost:Encodable{
    
    let api_token:String
    let file:Data
    let returnVar:String
    
    enum CodingKeys: String, CodingKey{
        case api_token
        case file
        case returnVar = "return"
    }
    
}

struct ACRCloudPost:Encodable{
    
    let sample:Data
    let access_key:String
    let sample_bytes:Int
    let timestamp:String
    let signature:String
    let data_type:String
    let signature_version:Int
    
    
}
