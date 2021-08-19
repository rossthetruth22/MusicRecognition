//
//  AlbumDetailViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/14/21.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var albumHeading: UILabel!
    @IBOutlet weak var mainAlbumCover: UIImageView!
    @IBOutlet weak var backgroundAlbumCover: UIImageView!
    var container:CatalogData!
    var album:Album!
    var songs:[Song]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getAlbumSongs()
        tableView.delegate = self
        tableView.dataSource = self
        let albumViewModel = AlbumViewModel(album)
        albumHeading.text = albumViewModel.albumHeading
        //mainAlbumCover.image = albumViewModel.image
        //backgroundAlbumCover.image = albumViewModel.image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func getAlbumSongs(){
        
        do{
            self.songs = try container.getAlbumSongs(self.album)
        }catch{
            
        }
        
    }

}

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //viewModel
        let songViewModel = SongViewModel(songs[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumSongDisplayCell") as? SongDisplayCell{
            cell.songArtist.text = songViewModel.artistName
            cell.songTrackCount.text = songViewModel.trackCount
            cell.songName.text = songViewModel.songName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
}
