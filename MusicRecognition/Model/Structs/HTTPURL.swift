//
//  HTTPURL.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/6/21.
//

import Foundation

struct HTTPURL{
    let scheme:String
    let host:String
    let path:String
    let method:String?
    let parameters:[String:AnyObject]
    
    init(_ scheme:String, _ host:String, _ path:String, _ method:String? = nil, _ parameters: [String:AnyObject]){
        self.scheme = scheme
        self.host = host
        self.path = path
        self.method = method
        self.parameters = parameters
    }
    
//    init(_ scheme:String, _ host:String, _ path:String){
//        self.scheme = scheme
//        self.host = host
//        self.path = path
//        //self.parameters = parameters
//    }
}

