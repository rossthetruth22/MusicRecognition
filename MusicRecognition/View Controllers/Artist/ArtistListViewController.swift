//
//  ArtistViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/29/21.
//

import UIKit

class ArtistListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var container:CatalogData!
    var artists:[Artist]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getArtists()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func getArtists(){
        do{
            self.artists = try container.getAllArtists()
        }catch{
            
        }
        
    }

}

extension ArtistListViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    //artist view Model
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var artistViewModel = ArtistViewModel(artists[indexPath.row])
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistListCell", for: indexPath) as? ArtistListCell{
            cell.artistName.text = artistViewModel.artistName
            cell.albumCount.text = artistViewModel.artistAlbumCount
            cell.songCount.text = artistViewModel.artistSongCount
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 130)
    }
    
    
}
