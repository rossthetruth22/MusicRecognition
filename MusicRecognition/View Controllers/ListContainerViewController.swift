//
//  ListContainerViewControlelr.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/31/21.
//

import UIKit

class ListContainerViewController: UIViewController, NavigationDelegate {
    

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContainer: LabelView!
    var songListController: SongListViewController! = nil
    var albumListController: AlbumListViewController! = nil
    var artistListController: ArtistListViewController! = nil
    var playlistListController: PlaylistListViewController! = nil
    var container:CatalogData!
    
    var addButton:UIBarButtonItem!
    
    var songControllerCenter:CGFloat!
    var albumControllerCenter:CGFloat!
    var artistControllerCenter:CGFloat!
    var playlistControllerCenter:CGFloat!
    var currentTab = 0
    var currentController:UIViewController!
    var panTranslation = CGFloat(0.0)
    
    
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
        
        songListController.navigationDelegate = self
        albumListController.navigationDelegate = self
        artistListController.navigationDelegate = self
        playlistListController.navigationDelegate = self
        
        
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
        
        songControllerCenter = songListController.view.center.x
        albumControllerCenter = albumListController.view.center.x
        artistControllerCenter = artistListController.view.center.x
        playlistControllerCenter = playlistListController.view.center.x
        
        let selector = #selector(ListContainerViewController.handleButtonTap(_:))
        labelContainer.assignHandlers(selector)
        currentController = songListController

        // Do any additional setup after loading the view.
        
        let barItems = navigationItem.rightBarButtonItems
        addButton = barItems?.last
        addButton?.isEnabled = false
        addButton?.tintColor = UIColor.clear
        addButton.target = self
        addButton.action = #selector(addPlaylistTapped)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(pan)
        print(view.bounds.width)
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        resignFirstResponder()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func addChildController(_ controller:UIViewController, _ title:String){
        
    }
    
    @objc func handlePan(_ gesture:UIPanGestureRecognizer){
        
        switch gesture.state{
        
        case .began:
            panTranslation = CGFloat(0.0)
        case .changed:
            let currentTranslation = gesture.translation(in: gesture.view).x
            let difference = currentTranslation - panTranslation
            panTranslation = currentTranslation
            animateScreens(difference, abs(Double(currentTranslation)/200.0))
            
        case .cancelled, .ended:
            let currentTranslation = gesture.translation(in: gesture.view).x
            var panBound:CGFloat = 200.0
            if (currentController == songListController && currentTranslation > 0.0) || (currentController == playlistListController && currentTranslation < 0.0){
                panBound = 1000.0
            }
            let progress = abs(currentTranslation/panBound)
            
            if progress < 0.55{
                revertPanAnimation()
            }else{
                completePanAnimation()
            }
        default:
            break
        }

    }
    

    
    @objc func handleButtonTap(_ sender:UIButton){
        
        var moveTo = CGFloat()
        var fromCenter = CGFloat()
        
        switch currentController{
        case songListController:
            fromCenter = songControllerCenter
        case albumListController:
            fromCenter = albumControllerCenter
        case artistListController:
            fromCenter = artistControllerCenter
        case playlistListController:
            fromCenter = playlistControllerCenter
        default:
            fromCenter = CGFloat()
        }
            
        switch sender.tag{
        
        case 0:
            
            moveTo = fromCenter - songControllerCenter
            currentController = songListController
        case 1:
            moveTo = fromCenter - albumControllerCenter
            currentController = albumListController
        case 2:
            moveTo = fromCenter - artistControllerCenter
            currentController = artistListController
        case 3:
            moveTo = fromCenter - playlistControllerCenter
            currentController = playlistListController
            
//            addButton?.isEnabled = false
//            addButton?.tintColor = UIColor.clear
        
        default:
            moveTo = fromCenter - songControllerCenter
            currentController = songListController
    
        }
        
        UIView.animate(withDuration: 1.0) { [self] in
            self.songListController.view.center.x += moveTo
            self.albumListController.view.center.x += moveTo
            self.artistListController.view.center.x += moveTo
            self.playlistListController.view.center.x += moveTo
            
        } completion: { [weak self] result in
            if result{
                self?.labelTitle.text = sender.titleLabel?.text
                
                if let _ = self?.currentController as? PlaylistListViewController {
                    self?.addButton?.isEnabled = true
                    self?.addButton?.tintColor = UIColor.black
                    
                }else{
                    self?.addButton?.isEnabled = false
                    self?.addButton?.tintColor = UIColor.clear
                }
            }
        }
    }
    
    private func revertPanAnimation(){
        
        let fromCenter = view.center.x
        let distanceToMove = fromCenter - currentController.view.center.x
        
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut) {
            self.songListController.view.center.x += distanceToMove
            self.albumListController.view.center.x += distanceToMove
            self.artistListController.view.center.x += distanceToMove
            self.playlistListController.view.center.x += distanceToMove
        } completion: { _ in
            //print("done")
        }
        
    }
    private func animateScreens(_ distance:CGFloat, _ percent:Double){
        
        var moveTo = CGFloat()
        var panMultiplier:CGFloat = 0.75
        if currentController == songListController || currentController == playlistListController{
            
            var percentPastCenter:CGFloat = 0.0
            let currentCenter = currentController.view.center.x
            let percentOfView = currentCenter/view.bounds.width
            if currentController == songListController{
                percentPastCenter = percentOfView-0.5
            }else{
                percentPastCenter = 0.5-percentOfView
            }
            
            if percentPastCenter >= 0.0{
                panMultiplier = 0.25
            }
        }
        
        let viewFraction = view.bounds.width * panMultiplier
        let multiplier = viewFraction/200.0
        moveTo = distance
        let distanceToMove = moveTo * multiplier
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.songListController.view.center.x += distanceToMove
            self.albumListController.view.center.x += distanceToMove
            self.artistListController.view.center.x += distanceToMove
            self.playlistListController.view.center.x += distanceToMove
        }, completion: nil)
        
    }
    
    private func completePanAnimation(){
        
        let screenCenter = view.center.x
        var newController:UIViewController! = nil
        let currentControllerCenter = currentController.view.center.x
        let isPannedLeft = currentControllerCenter < screenCenter ? true : false
        let finalPosition = isPannedLeft ? screenCenter - view.bounds.width : screenCenter + view.bounds.width
        let distanceToMove = finalPosition - currentControllerCenter
        
        //if current current is > center then you're swiping right and need to complete moving
        let standard = 0.3
        
        switch currentController{
        case songListController:
            newController = isPannedLeft ? albumListController : songListController
        case albumListController:
            newController = isPannedLeft ? artistListController : songListController
        case artistListController:
            newController = isPannedLeft ? playlistListController : albumListController
        case playlistListController:
            newController = isPannedLeft ? playlistListController : artistListController
        default:
            newController = songListController
        }
        
        var labelName = String()
        switch newController{
        case songListController:
            labelName = "Songs"
        case albumListController:
            labelName = "Albums"
        case artistListController:
            labelName = "Artists"
        case playlistListController:
            labelName = "Playlists"
        default:
            labelName = "Songs"
        }
        
        
        
        UIView.animate(withDuration: standard, delay: 0.0, options: .curveEaseOut) {
            self.songListController.view.center.x += distanceToMove
            self.albumListController.view.center.x += distanceToMove
            self.artistListController.view.center.x += distanceToMove
            self.playlistListController.view.center.x += distanceToMove
        } completion: { _ in
            self.currentController = newController
            self.labelTitle.text = labelName
        }

        
    }
    
    @objc func addPlaylistTapped(){
        //present an alert controller to get the name off the playlist
        
        let alertController = UIAlertController(title: "New Playlist", message: "Enter your playlist name", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        var textField:UITextField! = nil
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            //Create New Playlist
            self.createPlaylist(textField.text!)
            
        }
        
        alertController.addTextField { alertText in
            textField = alertText
            textField.delegate = self
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func createPlaylist(_ name:String){
        //check if playlist currently exists
        if container.createPlaylist(name: name){
            //push controller and then present screen
            print("Yassssss")
        }else{
            //couldn't/didn't create playlist
            print("Nope")
        }
    }
    
    
}



extension ListContainerViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
