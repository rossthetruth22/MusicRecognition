//
//  SongViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit

class SongViewController: UIViewController {

    var song:AudDSong!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
        

        // Do any additional setup after loading the view.
    }
    
    func configureScreen(){
        let identifyViewModel = IdentifyViewModel(song)
        
        songName.text = identifyViewModel.songName
        artistName.text = identifyViewModel.artistName
        albumName.text = identifyViewModel.albumName
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        do{
            try CatalogData.shared.createSong(song: self.song)
        }catch{
            print(error.localizedDescription)
        }
        
        self.dismiss(animated: true, completion: nil)
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
