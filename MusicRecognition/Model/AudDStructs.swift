//
//  ACRStructs.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/3/21.
//

import Foundation



struct AudDResponse:Decodable{
    let result:AudDSong
    let status:String
}

struct AudDSong: Decodable{
    let title:String
    let album:String
    let artist:String
    let label:String
    let lyrics:Lyrics?
    
}

struct Lyrics:Decodable{
    let artist:String
    let artist_id:String
    let full_title:String
    let lyrics:String
}
