//
//  AlbumPhotosCollectionViewController.swift
//  Albumera
//
//  Created by Sayed Abdo on 7/23/18.
//  Copyright © 2018 TheAmrAli. All rights reserved.
//

import UIKit

class AlbumPhotosCollectionViewController: UICollectionViewController ,  UICollectionViewDelegateFlowLayout {
    
    var CurrentAlbum = Album()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = CurrentAlbum.title
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let LeftAndRightPadding : CGFloat = 2.0
        let FullWidth = collectionView.frame.width
        var ItemSize = CGSize(width: (FullWidth - LeftAndRightPadding)  , height: (FullWidth - LeftAndRightPadding) )
        if Double(FullWidth) <= 400.0{
            ItemSize =  CGSize(width: (FullWidth - LeftAndRightPadding)/2.0 , height: (FullWidth - LeftAndRightPadding)/2.0 )

        }else if Double(FullWidth) > 400.0 {
            ItemSize =  CGSize(width: (FullWidth - LeftAndRightPadding)/3.0 , height: (FullWidth - LeftAndRightPadding)/3.0 )
        }
        return ItemSize
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (CurrentAlbum.images.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell		
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)as? AlbumPhotoCollectionViewCell
        
        cell?.ImgviewPhoto.image = UIImage(data: CurrentAlbum.images[indexPath.item])
    
        return cell!
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let FullImageVC = FullImageViewController()
        FullImageVC.SenderIndex = indexPath
       // FullImageVC.ImageArray.insert(UIImage(data: CurrentAlbum.images[indexPath.item])!, at: 0)
        for data in CurrentAlbum.images{
            FullImageVC.ImageArray.append(UIImage(data: data)!)
        }
       // FullImageVC.ImageArray.remove(at: indexPath.item + 1)
        self.navigationController?.pushViewController(FullImageVC, animated: true)
    }
    
    
}
