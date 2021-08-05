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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else{return}
        do{
            songs =  try container.getSongs()
        }catch{
            print("error getting song view controller data")
        }
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

}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell{
            let song = songs[indexPath.row]
            cell.albumName.text = song.albumName
            cell.artistName.text = song.artistName
            cell.songName.text = song.name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}

extension SongListViewController: ContextDelegate{
    
    @objc func handleChanges(notification: NSNotification) {
        print("recognized save")
    }
    
    
}
