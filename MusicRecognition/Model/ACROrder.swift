//
//  ACROrder.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/13/21.
//

import Foundation

enum ACROrder:Int{

    case score
    case other
    
    var order:Int{
        switch self{
        case .score:
            return self.rawValue
        case .other:
            return 0

        }
        
    }
    
    init(_ score:Int?){
        
        if let _ = score{
            self = .score
        }else{
            self = .other
        }
    }

    
}
