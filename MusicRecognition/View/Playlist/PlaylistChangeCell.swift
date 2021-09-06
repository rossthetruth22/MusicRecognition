//
//  PlaylistChangeCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/17/21.
//

import UIKit

class PlaylistChangeCell: UITableViewCell {

    @IBOutlet weak var playlistSongArtistName: UILabel!
    @IBOutlet weak var playlistSongName: UILabel!
    @IBOutlet weak var selectImage: RoundImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
