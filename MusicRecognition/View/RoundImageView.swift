//
//  RoundImageView.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/28/21.
//

import UIKit

class RoundImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor

    }

}
