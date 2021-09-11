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
    weak var navigationDelegate:NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getPlaylists()
        NotificationCenter.default.addObserver(self, selector: #selector(handleChanges(notification: )), name: .NSManagedObjectContextDidSave, object: container.viewContext)
        //print(playlists.count)
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
    
    func setupDetailController(_ playlist:Playlist){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playlistDetailController = storyboard.instantiateViewController(withIdentifier: "PlaylistDetailController") as? PlaylistDetailViewController{
            //let currentAlbum = albums[indexPath.row]
            playlistDetailController.playlist = playlist
            playlistDetailController.container = container
            //setupColor
            let selectedIndex = tableView.indexPathForSelectedRow
            let selectedCell = tableView.cellForRow(at: selectedIndex!) as! PlaylistListCell
            playlistDetailController.color = selectedCell.color
            self.navigationDelegate?.pushViewController(playlistDetailController)
            
        }
    }
    
    func assignColor(_ index:Int) -> UIColor{
        let number = index % 5
        
        switch number{
        case 0:
            return .pastelRed
        case 1:
            return .lightPastelGreen
        case 2:
            return .lightPastelYellow
        case 3:
            return .pastelOrange
        case 4:
            return .pastelPurple
        default:
            return .pastelRed
        }
    }

}

extension PlaylistListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlistViewModel = PlaylistViewModel(playlists[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistListCell") as? PlaylistListCell{
            cell.playlistLetter.text = playlistViewModel.playlistLetter
            cell.playlistName.text = playlistViewModel.playlistName
            cell.playlistSongCount.text = playlistViewModel.playlistSongCount
            cell.color = assignColor(indexPath.row)
            cell.contentView.backgroundColor = cell.color
            //cell.albumName.text = song.albumName
            //cell.artistName.text = song.artistName
            //print(song.artistName)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        setupDetailController(playlist)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
}
extension PlaylistListViewController: ContextDelegate{
    
    @objc func handleChanges(notification: NSNotification) {
        getPlaylists()
        tableView.reloadData()
    }
    
    
}
