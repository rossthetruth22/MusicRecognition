//
//  ListContainerViewControlelr.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/31/21.
//

import UIKit

class ListContainerViewController: UIViewController {

    @IBOutlet weak var labelContainer: UIView!
    var songListController: SongListViewController! = nil
    var albumListController: AlbumListViewController! = nil
    var artistListController: ArtistListViewController! = nil
    var playlistListController: PlaylistListViewController! = nil
    var container:CatalogData!
    
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            UIView.animate(withDuration: 0.6) {
//                self.songListController.view.frame.origin.x -= self.view.frame.width
//                self.albumListController.view.frame.origin.x -= self.view.frame.width
//                self.artistListController.view.frame.origin.x -= self.view.frame.width
//                self.playlistListController.view.frame.origin.x -= self.view.frame.width
//            } completion: { val in
//                print(val)
//            }
//        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        songListController = storyboard.instantiateViewController(identifier: "SongList")
        albumListController = storyboard.instantiateViewController(identifier: "AlbumList")
        artistListController = storyboard.instantiateViewController(identifier: "ArtistList")
        playlistListController = storyboard.instantiateViewController(identifier: "PlaylistList")
        
        container = CatalogData.shared
        guard container != nil else{
            print("container is not available")
            return
        }
        
        songListController.container = container
        albumListController.container = container
        artistListController.container = container
        playlistListController.container = container
        
        
//        guard let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SongList") as? SongListViewController else {return}
        //self.addChild(controller)
        
        self.addChild(songListController)
        self.addChild(albumListController)
        self.addChild(artistListController)
        self.addChild(playlistListController)

        let labelY = labelContainer.frame.maxY - 5.0
        //self.view.addSubview(controller.view)
        
        self.view.addSubview(songListController.view)
        self.view.addSubview(albumListController.view)
        self.view.addSubview(artistListController.view)
        self.view.addSubview(playlistListController.view)
        
//        controller.view.frame = CGRect(x: view.frame.origin.x, y: labelY, width: view.frame.width, height: view.frame.height-labelY)
//
//        controller.didMove(toParent: self)
        
        
        
        let xDiff = view.frame.width-view.frame.origin.x
        var xValue = 0.0 * xDiff
//        var theFrame = CGRect(x: view.frame.origin.x, y: labelY, width: view.frame.width, height: view.frame.height-labelY)
        var theFrame = CGRect(x: xValue, y: labelY, width: view.frame.width, height: view.frame.height-labelY)
        
        songListController.view.frame = theFrame
        xValue = 1.0 * xDiff
        theFrame = CGRect(x: xValue, y: labelY, width: view.frame.width, height: view.frame.height-labelY)
        albumListController.view.frame = theFrame
            xValue = 2.0 * xDiff
        theFrame = CGRect(x: xValue, y: labelY, width: view.frame.width, height: view.frame.height-labelY)
        artistListController.view.frame = theFrame
        xValue = 3.0 * xDiff
        theFrame = CGRect(x: xValue, y: labelY, width: view.frame.width, height: view.frame.height-labelY)
        playlistListController.view.frame = theFrame
        
        songListController.didMove(toParent: self)
        albumListController.didMove(toParent: self)
        artistListController.didMove(toParent: self)
        playlistListController.didMove(toParent: self)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func addChildController(_ controller:UIViewController, _ title:String){
        
    }
}
