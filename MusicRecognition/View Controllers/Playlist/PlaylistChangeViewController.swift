//
//  PlaylistChangeViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class PlaylistChangeViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    var container:CatalogData!
    var playlist:Playlist!
    var songs:[Song]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        //getPlaylistSongs()
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    private func getPlaylistSongs() -> [Song]{
//        do{
//            //self.songs = container.getAllSongsForPlaylist(Playlist)
//        }catch{
//            
//        }
//    }

}

extension PlaylistChangeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songViewModel = SongViewModel(songs[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistChangeCell") as? PlaylistChangeCell{
            cell.playlistSongName.text = songViewModel.songName
            cell.playlistSongArtistName.text = songViewModel.artistName

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //depends on source
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}
