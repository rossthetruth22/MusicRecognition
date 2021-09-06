//
//  AlbumListCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class AlbumListCell: UITableViewCell {

    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName:UILabel!
    @IBOutlet weak var albumArtist:UILabel!
    @IBOutlet weak var albumSongCount:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
