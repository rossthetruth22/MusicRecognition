//
//  SongDisplayCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class SongDisplayCell: UITableViewCell {

    weak var songTrackCount:UILabel!
    weak var songName:UILabel!
    weak var songArtist:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
