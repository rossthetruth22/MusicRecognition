//
//  ContextProtocol.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/5/21.
//

import Foundation

@objc protocol ContextDelegate{
    @objc func handleChanges(notification: NSNotification)
}
