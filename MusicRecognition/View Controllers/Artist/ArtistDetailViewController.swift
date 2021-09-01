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
    weak var navigationDelegate:NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getAlbums()
        getArtistSongs()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: "SongCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        let artistViewModel = ArtistViewModel(artist)
        artistHeading.text = artistViewModel.artistName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        //sort albums by date
        do{
            self.albums = try container.getAllAlbumsForArtist(artist)
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
        //if let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistSongDisplayCell") as? SongDisplayCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as? SongCell{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let songDetailController = storyboard.instantiateViewController(withIdentifier: "SongDetailController") as? SongDetailViewController{
            let currentSong = songs[indexPath.row]
            songDetailController.song = currentSong
            self.navigationDelegate?.pushViewController(songDetailController)
            
        }
    }
    
}

extension ArtistDetailViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCoverCell", for: indexPath) as? AlbumCoverCell{
            let currentAlbum = albums[indexPath.row]
            let viewModel = AlbumViewModel(currentAlbum)
            let picFetch = PictureFetch(viewModel.smallImageURL)
            cell.albumCover.image = picFetch.image
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(5)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cells = Double(albums.count)
        let spacing = 10.0
        let totalSpaces = cells - 1.0
        let totalSpacing = spacing * totalSpaces
        let contentSize = collectionView.bounds.size.height * CGFloat(cells) + CGFloat(totalSpacing)
        
        let collectionWidth = collectionView.bounds.size.width
        if contentSize < collectionWidth{
            let inset = (collectionWidth - contentSize)/2.0
            return UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        }

        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
    }
    
    
}
