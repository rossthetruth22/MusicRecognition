//
//  ArtistDetailViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/14/21.
//

import UIKit

class ArtistDetailViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var artistHeading: UILabel!
    
    
    var container:CatalogData!
    
    var artist:Artist!
    var songs:[Song]!
    var albums:[Album]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getAlbums()
        getArtistSongs()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        let artistViewModel = ArtistViewModel(artist)
        artistHeading.text = artistViewModel.artistName
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
    
    private func getArtistSongs(){
        do{
            self.songs = try container.getAllArtistSongs(artist)
        }catch{
            
        }
    }

}

extension ArtistDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let songViewModel = SongViewModel(songs[indexPath.row])
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistSongDisplayCell") as? SongDisplayCell{
            cell.songArtist.text = songViewModel.artistName
            //cell.songTrackCount.text = songViewModel.trackCount
            cell.songName.text = songViewModel.songName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}

extension ArtistDetailViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCoverCell", for: indexPath) as? AlbumCoverCell{
            //cell.albumCover.image = albums[indexPath.row].image
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    
}
