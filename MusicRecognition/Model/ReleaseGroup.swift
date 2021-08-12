//
//  ReleaseGroup.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/10/21.
//

import Foundation

enum ReleaseGroup:String{
    
    case album = "Album"
    case single = "Single"
    case ep = "EP"
    case broadcast = "Broadcast"
    case other = "Other"
    case compilation = "Compilation"
    case soundtrack = "Soundtrack"
    case spokenWord = "Spokenword"
    case interview = "Interview"
    case audiobook = "Audiobook"
    case audioDrama = "Audio drama"
    case live = "Live"
    case remix = "Remix"
    case djMix = "DJ-mix"
    case mixtape = "Mixtape/Street"
    
    var order:Int{
        switch self{
        case .album:
            return 0
        case .single:
            return 1
        case .ep:
            return 2
        case .compilation:
            return 3
        case .soundtrack:
            return 4
        case .mixtape:
            return 5
        case .remix:
            return 6
        case .live:
            return 7
        default:
            return 100

        }
        
    }

    
}
