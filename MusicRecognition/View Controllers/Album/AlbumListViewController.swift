//
//  AlbumViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit

class AlbumListViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    var container:CatalogData!
    var albums:[Album]!
    weak var navigationDelegate:NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard container != nil else{return}
        getAlbums()
        NotificationCenter.default.addObserver(self, selector: #selector(handleChanges(notification: )), name: .NSManagedObjectContextDidSave, object: container.backgroundContext)
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
    
    private func getAlbums(){
        do{
            self.albums = try container.getAlbums()
        }catch{
            
        }
    }

}

extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListCell") as? AlbumListCell{
            
            let album = albums[indexPath.row]
            let albumViewModel = AlbumViewModel(album)
            cell.albumName.text = albumViewModel.albumName
            cell.albumArtist.text = albumViewModel.albumArtist
            cell.albumSongCount.text = albumViewModel.albumSongCount
            let picFetch = PictureFetch(albumViewModel.smallImageURL)
            cell.albumCover.image = picFetch.image
         
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let albumDetailController = storyboard.instantiateViewController(withIdentifier: "AlbumDetailController") as? AlbumDetailViewController{
            let currentAlbum = albums[indexPath.row]
            albumDetailController.album = currentAlbum
            let currentCell = tableView.cellForRow(at: indexPath) as! AlbumListCell
            let currentImage = currentCell.albumCover.image
            albumDetailController.image = currentImage
            albumDetailController.container = container
            self.navigationDelegate?.pushViewController(albumDetailController)
            
        }
    }
    
}

extension AlbumListViewController: ContextDelegate{
    
    @objc func handleChanges(notification: NSNotification) {
        print("recognized save album")
        getAlbums()
        tableView.reloadData()
    }
    
    
}
