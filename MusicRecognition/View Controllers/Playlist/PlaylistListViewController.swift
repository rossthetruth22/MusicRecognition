//
//  PlaylistViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit

class PlaylistListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var container:CatalogData!
    var playlists:[Playlist]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getPlaylists()
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
    
    private func getPlaylists(){
        do{
            self.playlists = try container.getAllPlaylists()
        }catch{
            
        }
    }

}

extension PlaylistListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var playlistViewModel = PlaylistViewModel(playlists[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistListCell") as? PlaylistListCell{
            cell.playlistLetter.text = playlistViewModel.playlistLetter
            cell.playlistName.text = playlistViewModel.playlistName
            cell.playlistSongCount.text = playlistViewModel.playlistSongCount
            //cell.albumName.text = song.albumName
            //cell.artistName.text = song.artistName
            //print(song.artistName)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
}
