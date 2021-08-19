//
//  LabelView.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/14/21.
//

import UIKit

class LabelView: UIView {


    @IBOutlet weak var songs:UIButton!
    @IBOutlet weak var albums:UIButton!
    @IBOutlet weak var artists:UIButton!
    @IBOutlet weak var playlists:UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func assignHandlers(_ selector:Selector){
        //songs.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        songs.addTarget(nil, action: selector, for: .touchUpInside)
        albums.addTarget(nil, action: selector, for: .touchUpInside)
        artists.addTarget(nil, action: selector, for: .touchUpInside)
        playlists.addTarget(nil, action: selector, for: .touchUpInside)
    }

}
