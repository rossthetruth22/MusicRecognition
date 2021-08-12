//
//  ACRStructs.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/3/21.
//

import Foundation



struct AudDResponse:Decodable{
    let result:AudDSong?
    let status:String
}

struct AudDSong: Decodable{
    let title:String
    let album:String
    let artist:String
    let label:String
    let lyrics:Lyrics?
    var musicbrainz:[MusicBrainz]?
    
}

struct Lyrics:Decodable{
    let artist:String
    let artist_id:String
    let full_title:String
    let lyrics:String
}


struct MusicBrainz:Decodable{
    let artistCredit:[MusicBrainzArtistCredit]
    let id:String
    var releases:[MusicBrainzRelease]
    
    enum CodingKeys: String, CodingKey{
        case artistCredit = "artist-credit"
        case id
        case releases
    }
    
    mutating func sortRelease(){
        releases.sort { one, two in
            let typeOne = one.releaseGroup.primaryType
            let typeTwo = two.releaseGroup.primaryType
            
            let rawOne = ReleaseGroup(rawValue: typeOne)!.order
            let rawTwo = ReleaseGroup(rawValue: typeTwo)!.order
            
            return rawOne < rawTwo
        }
    }
    
}

struct MusicBrainzRelease:Decodable{
    let artistCredit:[MusicBrainzArtistCredit]
    let id:String
    let trackCount:Int
    let releaseGroup:MusicBrainzReleaseGroup
    
    enum CodingKeys: String, CodingKey{
        case artistCredit = "artist-credit"
        case id
        case trackCount = "track-count"
        case releaseGroup = "release-group"
    }
    
}

struct MusicBrainzArtistCredit:Decodable{
    let artist:MusicBrainzArtist
    let name:String
    
}


struct MusicBrainzArtist:Decodable{
    let id:String
    let name:String
}

struct MusicBrainzReleaseGroup:Decodable{
    
    let id:String
    let primaryType:String
    let title:String
    let typeID:String
    
    enum CodingKeys:String, CodingKey{
        case id
        case primaryType = "primary-type"
        case title
        case typeID = "type-id"
    }

}

struct CoverArt:Decodable{
    let images:[CoverArtImages]
}

struct CoverArtImages:Decodable{
    let image:String
    let thumbnails:CoverArtThumbnail
}

struct CoverArtThumbnail:Decodable{
    
    let size1200:String?
    let size250:String?
    let size500:String?
    let sizeLarge:String
    let sizeSmall:String
    
    enum CodingKeys:String, CodingKey{
        case size1200 = "1200"
        case size250 = "250"
        case size500 = "500"
        case sizeLarge = "large"
        case sizeSmall = "small"
    }
}
