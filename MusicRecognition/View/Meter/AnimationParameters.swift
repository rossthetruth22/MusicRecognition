//
//  AnimationParameters.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 9/2/21.
//

import Foundation

class AnimationParameters{
    let index:Int
    let start:Int
    let end:Int
    let duration:Double
    var shouldRepeat:Bool
    
    init(index:Int, start:Int, end:Int, duration:Double){
        self.index = index
        self.start = start
        self.end = end
        self.duration = duration
        self.shouldRepeat = true
    }
    
}
