//
//  SongListCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/1/21.
//

import UIKit

class SongListCell: UITableViewCell {

    @IBOutlet weak var songCoverPic: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var spacing: UIView!
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var cellSpace: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellContainer.layer.cornerRadius = cellContainer.frame.size.width/16
        self.cellContainer.layer.masksToBounds = true
        //self.layer.cornerRadius = self.frame.size.width/
        //let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        //contentView.frame = contentView.frame.inset(by: margins)
    }

}
