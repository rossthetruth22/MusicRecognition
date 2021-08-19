//
//  PlaylistListCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class PlaylistListCell: UITableViewCell {

    @IBOutlet weak var playlistLetter:UILabel!
    @IBOutlet weak var playlistName:UILabel!
    @IBOutlet weak var playlistSongCount:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
