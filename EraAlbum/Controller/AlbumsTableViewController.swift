//
//  AlbumsTableViewController.swift
//  Albumera
//
//  Created by Sayed Abdo on 7/23/18.
//  Copyright © 2018 TheAmrAli. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {

    //Outlets
    
    @IBOutlet weak var LblNoExsitingAlbums: UILabel!
    
    let userDefaults =   UserDefaults.standard
    
    var Albums = [Album]()
    ////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //Add Array Of Albums in UserDefaults
        let AlbumArray  = [Album]()
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: AlbumArray)
        userDefaults.set(encodedData, forKey: "AlbumArray")
        userDefaults.synchronize()
        
        //Checking For Exsiting Album
        if (UserDefaults.standard.array(forKey: "AlbumsArray")?.isEmpty)! == true {
            self.LblNoExsitingAlbums.isHidden = false
            self.tableView.isHidden = true
            
        }else{
            
            self.tableView.isHidden = false
            self.LblNoExsitingAlbums.isHidden = true
            
            //Retrive AlbumArray From UserDefaults
            
            let decoded  = userDefaults.object(forKey: "AlbumArray") as! Data
             self.Albums = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Album]
            
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Albums.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumsTableViewCell

        cell?.configureCell(ImagesCount: Albums[indexPath.row]._imagesArray.count , AlbumName: Albums[indexPath.row]._title , Imgpreview: Albums[indexPath.row]._PreviewImage)
        
        return cell!
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
