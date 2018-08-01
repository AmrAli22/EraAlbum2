//
//  AlbumsTableViewCell.swift
//  Albumera
//
//  Created by Amr Ali on 7/23/18.
//  Copyright © 2018 TheAmrAli. All rights reserved.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var LblImagesCount: UILabel!
    @IBOutlet weak var LblAlbumName: UILabel!
    @IBOutlet weak var ImgViewAlbumPreview: UIImageView!
    
    /////////////////////
    
    func configureCell( ImagesCount : Int , AlbumName : String ,Imgpreview : UIImage ){
        
        self.LblAlbumName.text = AlbumName
        
        if ImagesCount < 10 {
            self.LblImagesCount.text = "\(ImagesCount) Photo"
        }else{
            self.LblImagesCount.text = "\(ImagesCount) Photos"
        }
        
        self.ImgViewAlbumPreview.image = Imgpreview
        
    }

   

}
