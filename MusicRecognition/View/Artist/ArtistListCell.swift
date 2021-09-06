//
//  ArtistListCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class ArtistListCell: UICollectionViewCell {
    
    @IBOutlet weak var artistName:UILabel!
    @IBOutlet weak var albumCount:UILabel!
    @IBOutlet weak var songCount:UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width/8
        contentView.layer.cornerRadius = contentView.frame.size.width/8
        contentView.layer.masksToBounds = true
        
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.75
        self.layer.masksToBounds = false
    }
    
}
