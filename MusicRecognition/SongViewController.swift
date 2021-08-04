//
//  SongViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit

class SongViewController: UIViewController {

    var song:AudDResult?
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songName.text = song?.title
        artistName.text = song?.artist
        albumName.text = song?.album

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
