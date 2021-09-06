//
//  OtherSongCell.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/28/21.
//

import UIKit

class OtherSongCell: UITableViewCell {
    
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

}
