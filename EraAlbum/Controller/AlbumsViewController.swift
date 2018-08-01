//
//  ViewController.swift
//  EraAlbum
//
//  Created by Sayed Abdo on 7/23/18.
//  Copyright © 2018 TheAmrAli. All rights reserved.
//

import UIKit
import CoreData

class AlbumsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    

    //Outlets
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var LblNotAlbumYet: UILabel!
    
    /////////////////
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var Albums = [Album]()
    /////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TableView.delegate = self
        TableView.dataSource = self
        
        
        
    }
    
    ////////////////////
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.fetchCoreDataObjects()
         self.TableView.reloadData()
    }
    
    ///////////////////
    
    @objc func willEnterForeground() {
            self.fetchCoreDataObjects()
            self.TableView.reloadData()
        
    }

    
    ////////////////// Get Data From CoreData
    
    func fetchCoreDataObjects() {
        self.fetch{ (complete) in
                
            if complete {
                if self.Albums.count >= 1 {
                    self.TableView.isHidden = false
                   self.LblNotAlbumYet.isHidden = true
                } else {
                    self.TableView.isHidden = true
                    self.LblNotAlbumYet.isHidden = false
                }
            }
        }
    }

    ////////////////
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumsTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(ImagesCount: (Albums[indexPath.row].images.count) , AlbumName: Albums[indexPath.row].title!, Imgpreview: UIImage(data: Albums[indexPath.row].previewImage!)! )
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeAlbum(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
      
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
        ////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
   
        if segue.identifier == "ShowAlbum" {
            
            if let cell = sender as? UITableViewCell {
                let index = TableView.indexPath(for: cell)!.row
                
            let destinationController = segue.destination as! AlbumPhotosCollectionViewController
            destinationController.CurrentAlbum = Albums[index]
            
            }
        } else if segue.identifier == "ShowAddAlbumSegue" {
        
        let destnationController = segue.destination as! AddAlbumViewController
            destnationController.Albums = Albums
    
        }
    }

}

extension AlbumsViewController{
    
    func removeAlbum(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(Albums[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfully removed Album!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    
    //////////////////
    
    public func fetch(completion: @escaping (_ complete: Bool) -> ()) {
       

            guard let managedContext = self.appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
        
        do {
            self.Albums = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
      
    }
    
}



