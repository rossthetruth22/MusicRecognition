//
//  SongViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit

class SongListViewController: UIViewController {

    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    
    var container:CatalogData!
    var songs = [Song]()
    weak var navigationDelegate:NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else{return}
        getSongs()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleChanges(notification: )), name: .NSManagedObjectContextDidSave, object: container.backgroundContext)
        //tableView.inte

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
    
    private func getSongs(){
        do{
            songs =  try container.getSongs()
        }catch{
            print("error getting song view controller data")
        }
    }
    
    

}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell{
            let song = songs[indexPath.row]
            
            let songViewModel = SongViewModel(song)
            let picFetch = PictureFetch(songViewModel.smallImageURL)
            cell.songCoverPic.image = picFetch.image
            cell.songName.text = songViewModel.songName
            
            if let new = songViewModel.artistName{
                cell.artistName.text = new
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let songDetailController = storyboard.instantiateViewController(withIdentifier: "SongDetailController") as? SongDetailViewController{
            let currentSong = songs[indexPath.row]
            songDetailController.song = currentSong
            let currentCell = tableView.cellForRow(at: indexPath) as! SongListCell
            let currentImage = currentCell.songCoverPic.image
            songDetailController.image = currentImage
            self.navigationDelegate?.pushViewController(songDetailController)
            
        }
    }
    
}

extension SongListViewController: ContextDelegate{
    
    @objc func handleChanges(notification: NSNotification) {
        print("recognized save")
        getSongs()
        tableView.reloadData()
    }
    
    
}
