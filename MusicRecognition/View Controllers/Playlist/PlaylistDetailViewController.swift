//
//  PlaylistDetailViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class PlaylistDetailViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
    var container:CatalogData!
    var playlist:Playlist!
    var songs:[Song]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getSongsForPlaylist()
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
    
    private func getSongsForPlaylist(){
        do{
            self.songs = try container.getAllSongsForPlaylist(playlist)
        }catch{
            
        }
    }

}

extension PlaylistDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songViewModel = SongViewModel(songs[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongDisplayCell{
            cell.songArtist.text = songViewModel.artistName
            //cell.songTrackCount.text = songViewModel.trackCount
            cell.songName.text = songViewModel.songName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
}
