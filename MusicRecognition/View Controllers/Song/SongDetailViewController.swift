//
//  SongDetailViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/14/21.
//

import UIKit

class SongDetailViewController: UIViewController {

    
    var song: Song!
    @IBOutlet weak var songHeading: UILabel!
    @IBOutlet weak var songAlbumCover: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songAlbum: UILabel!
    @IBOutlet weak var songDuration: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        let songViewModel = SongViewModel(song)
        songHeading.text = songViewModel.songHeading
        //songAlbumCover.image = songViewModel.image
        songTitle.text = songViewModel.songName
        songArtist.text = songViewModel.artistName
        songAlbum.text = songViewModel.albumName
        songDuration.text = songViewModel.duration
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func deleteSongPressed(_ sender: UIButton) {
        //Handle delete
        //TODO: Add in delete function
    }
    

}
