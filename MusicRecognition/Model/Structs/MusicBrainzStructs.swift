//
//  MusicBrainzStructs.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/11/21.
//

import Foundation

struct RealMusicbrainz:Decodable{
    
    let recordings:[RealMusicbrainzRecording]?
}

struct RealMusicbrainzRecording:Decodable{
    
    let id:String
    let score:Int
    let title:String
    let disambiguation:String? = nil
    let artistCredit:[RealMusicbrainzArtistCredit?]?
    let firstReleaseDate:String?
    let releases:[RealMusicbrainzRelease]?
    let isrcs:[String]? = nil
    var length:Int? = 0
    
    enum CodingKeys:String,CodingKey{
        case id
        case score
        case title
        case artistCredit = "artist-credit"
        case firstReleaseDate = "first-release-date"
        case releases
        case length
    }
    
}


struct RealMusicbrainzArtistCredit:Decodable{
    
    let joinphrase:String?
    let name:String
    let artist:RealMusicbrainzArtist
    
}

struct RealMusicbrainzArtist:Decodable{
    let id:String
    let name:String
    
}

struct RealMusicbrainzRelease:Decodable{
    let id:String
    let title:String
    let status:String?
    let disambiguation:String?
    let artistCredit:[RealMusicbrainzArtistCredit?]?
    let releaseGroup:RealMusicbrainzReleaseGroup
    let date:String?
    
    enum CodingKeys:String,CodingKey{
        case id
        case title
        case status
        case disambiguation
        case artistCredit = "artist-credit"
        case releaseGroup = "release-group"
        case date
    }
    
}

struct RealMusicbrainzReleaseGroup:Decodable{
    let id:String
    let typeID:String?
    let primaryTypeID:String?
    let title:String
    let primaryType:String?
    
    enum CodingKeys:String,CodingKey{
        case id
        case typeID = "type-id"
        case primaryTypeID = "primary-type-id"
        case title
        case primaryType = "primary-type"
    }
}

struct RealMusicBrainzReleaseOnly:Decodable{
    
}
