//
//  PlaylistChangeViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/16/21.
//

import UIKit

class PlaylistChangeViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var changeSongs: RoundedButton!
    @IBOutlet weak var viewTitle:UILabel!
    var buttonPosition:CGFloat!
    
    var container:CatalogData!
    var playlist:Playlist!
    var songs:[Song]!
    var oldSongs:[Song]?
    var add:Bool!
    
    var selectedIndexPaths = Set<IndexPath>()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        if add{
            viewTitle.text = "Playlist Add"
            getSongs()
        }else{
            viewTitle.text = "Playlist Remove"
            songs = oldSongs
        }
        //getPlaylistSongs()
        tableView.delegate = self
        tableView.dataSource = self
        changeSongs.center.y += changeSongs.frame.size.height
        let currentPosition = changeSongs.frame.maxY
        let screenBottom = self.changeSongs.superview?.frame.maxY
        print(currentPosition)
        print(screenBottom)
        //buttonPosition = screenBottom - currentPosition
        //changeSongs.layer.position.y += buttonPosition
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
    
    private func getSongs(){
        do{
            songs =  try container.getSongs()
            guard oldSongs != nil else {return}
            let oldSongSet = Set(oldSongs!)
            songs = songs.filter({ song in
                return !oldSongSet.contains(song)
            })
        }catch{
            print("error getting song view controller data")
        }
        
//        let existingSongs = Set(
//        song
    }

    @IBAction func changeSongsTapped(_ button:UIButton){
        
        let selectedSongs = NSMutableSet()
        //var selectedSongs = [Song]()
        let selectedIndexes = selectedIndexPaths.map {$0.row }
        for (index, song) in songs.enumerated(){
            if selectedIndexes.contains(index){
                selectedSongs.add(song)
                //selectedSongs.append(song)
            }
        }
        if add{
            container.addSongsToPlaylist(selectedSongs, playlist)
        }else{
            container.removeSongsFromFromPlaylist(selectedSongs, playlist)
        }
        self.dismiss(animated: true, completion: nil)
    }

}

extension PlaylistChangeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songViewModel = SongViewModel(songs[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistChangeCell") as? PlaylistChangeCell{
            cell.playlistSongName.text = songViewModel.songName
            cell.playlistSongArtistName.text = songViewModel.artistName
            toggleBackground(cell, indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func toggleBackground(_ cell:PlaylistChangeCell, _ indexPath:IndexPath){
        
//        let cell = tableView.cellForRow(at: indexPath) as! PlaylistChangeCell
        if selectedIndexPaths.contains(indexPath){
            if add{
                cell.selectImage.backgroundColor = UIColor.pastelGreen
            }else{
                cell.selectImage.backgroundColor = UIColor.pastelRed
            }
            
        }else{
            cell.selectImage.backgroundColor = UIColor.clear
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //depends on source
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let currentCell = tableView.cellForRow(at: indexPath) as! PlaylistChangeCell
        selectedIndexPaths.insert(indexPath)
        toggleBackground(currentCell, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! PlaylistChangeCell
        selectedIndexPaths.remove(indexPath)
        toggleBackground(currentCell, indexPath)
    }
    
}
