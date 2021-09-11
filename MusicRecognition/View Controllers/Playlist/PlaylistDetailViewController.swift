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
    var color:UIColor!
    var firstTime:Bool?
    var addButton:PlaylistChangeItem!
    var trashButton:PlaylistChangeItem!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var playlistName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        let playlistViewModel = PlaylistViewModel(playlist)
        playlistName.text = playlistViewModel.playlistName
        getSongsForPlaylist()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChanges(notification: )), name: .NSManagedObjectContextDidSave, object: container.viewContext)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OtherSongCell", bundle: nil), forCellReuseIdentifier: "OtherSongCell")
        
        let barItems = navigationItem.rightBarButtonItems
        addButton = barItems?.first as? PlaylistChangeItem
        addButton.target = self
        addButton.bool = true
        addButton.action = #selector(addSongsTapped(_:))
        trashButton = barItems?.last as? PlaylistChangeItem
        trashButton.target = self
        trashButton.bool = false
        trashButton.action = #selector(addSongsTapped(_:))
        
        titleLabel.textColor = color
    }
    
    @objc func addSongsTapped(_ sender:PlaylistChangeItem){
        //present an alert controller to get the name off the playlist
        
        let bool = sender.bool
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlaylistChangeController") as! PlaylistChangeViewController
        controller.container = container
        controller.add = bool
        controller.playlist = playlist
        controller.oldSongs = songs
        
        present(controller, animated: true, completion: nil)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OtherSongCell") as? OtherSongCell{
            cell.songCoverPic.image = PictureFetch(songViewModel.smallImageURL).image
            cell.artistName.text = songViewModel.artistName
            cell.songName.text = songViewModel.songName
            cell.cellSpace.backgroundColor = color

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

extension PlaylistDetailViewController: ContextDelegate{
    
    @objc func handleChanges(notification: NSNotification) {
        getSongsForPlaylist()
        tableView.reloadData()
    }
}


