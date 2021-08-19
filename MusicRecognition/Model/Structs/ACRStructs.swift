//
//  ACRStructs.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/13/21.
//

import Foundation

struct ACRResponse:Decodable{
    var metadata:ACRMetadata?
    let status: ACRStatus
    let resultType:Int?
    
    enum CodingKeys:String,CodingKey{
        case metadata
        case status
        case resultType = "result_type"
    }
}


struct ACRMetadata:Decodable{
    var music:[ACRMusic]
}

struct ACRMusic:Decodable{
    let artists:[ACRArtist]
    let album:ACRAlbum
    let score:Int?
    let title:String
    let releaseDate:String?
    let label:String?
    
    enum CodingKeys:String,CodingKey{
        case artists
        case album
        case score
        case title
        case releaseDate = "release_date"
        case label
    }
}

struct ACRArtist:Decodable{
    let name:String
}

struct ACRAlbum:Decodable{
    let name:String
}

struct ACRStatus:Decodable{
    let msg:String
    let version:String
    let code:Int
}
