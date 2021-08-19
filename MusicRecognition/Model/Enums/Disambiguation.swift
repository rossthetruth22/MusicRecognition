//
//  Disambiguation.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/12/21.
//

import Foundation

enum Disambiguation:String{
    
    case other
    case clean
    
    var order:Int{
        switch self{
        case .clean:
            return 1
        case .other:
            return 0

        }
        
    }
    
    init(_ dis:String?){
        
        if let dis = dis{
            if dis.contains("clean"){
                self = .clean
            }else{
                self = .other
            }
        }else{
            self = .other
        }
    }

    
}
