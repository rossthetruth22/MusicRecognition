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
    weak var navigationDelegate:NavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard container != nil else{return}
        getArtists()
        NotificationCenter.default.addObserver(self, selector: #selector(handleChanges(notification: )), name: .NSManagedObjectContextDidSave, object: container.backgroundContext)
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
        let artistViewModel = ArtistViewModel(artists[indexPath.row])
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistListCell", for: indexPath) as? ArtistListCell{
            cell.artistName.text = artistViewModel.artistName
            cell.songCount.text = artistViewModel.artistSongCount
            cell.albumCount.text = artistViewModel.artistAlbumCount
            cell.artistName.backgroundColor = assignColor(indexPath.row)
            //cell.layer.borderWidth = 1.5
            //cell.layer.borderColor = UIColor.darkGray.cgColor
    
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //10 -- 10 -- 10
        let frameWidth = collectionView.bounds.size.width
        let totalSpace = CGFloat(15.0)
        let numberOfCells = 2
        let cellWidth = (frameWidth - totalSpace) / CGFloat(numberOfCells)
        let cellHeight = cellWidth + CGFloat(50)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let artistDetailController = storyboard.instantiateViewController(withIdentifier: "ArtistDetailController") as? ArtistDetailViewController{
            let currentArtist = artists[indexPath.row]
            artistDetailController.artist = currentArtist
            artistDetailController.container = container
            artistDetailController.navigationDelegate = self
            self.navigationDelegate?.pushViewController(artistDetailController)
            
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

extension ArtistListViewController:NavigationDelegate{
    func pushViewController(_ viewController: UIViewController) {
        self.navigationDelegate?.pushViewController(viewController)
    }
    
}

extension ArtistListViewController: ContextDelegate{
    
    @objc func handleChanges(notification: NSNotification) {
        //print("recognized save album")
        getArtists()
        collectionView.reloadData()
    }
    
    
}
