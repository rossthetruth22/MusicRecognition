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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard container != nil else{return}
        getAlbums()
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
            //let song = songs[indexPath.row]
         
            //cell.songName.text = song.name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}
