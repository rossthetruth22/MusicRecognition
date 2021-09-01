//
//  SongViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit

class SongViewController: UIViewController {

    
    //TODO:Change from type AUDSong to Core Data Song
    var song:AudDSong!
    var response:AudDResponse!
    var acr:ACRMusic!
    var image:UIImage?
    var songComponents:SongComponents!
    @IBOutlet weak var closeButton:UIButton!
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var coverArt: ShadowImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed{
            CatalogData.shared.clearContext()
        }
    }
    
    func configureScreen(){
        //let identifyViewModel = IdentifyViewModel(song)
//        songName.text = identifyViewModel.songName
//        artistName.text = identifyViewModel.artistName
//        albumName.text = identifyViewModel.albumName
        
        let idViewModel = IDViewModel(songComponents.song)
//        let idViewModel = IDViewModel(acr)
        songName.text = idViewModel.songName
        artistName.text = idViewModel.artistName
        albumName.text = idViewModel.albumName
           
        coverArt.image = image
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        do{
            //try CatalogData.shared.createSong(song: self.song)
            try CatalogData.shared.createSong(songComponents: songComponents)
        }catch{
            print(error.localizedDescription)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func closeTapped(_ sender: UIButton) {
        
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
