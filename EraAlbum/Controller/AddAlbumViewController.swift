//
//  AddAlbumViewController.swift
//  Albumera
//
//  Created by Amr Ali on 7/23/18.
//  Copyright © 2018 TheAmrAli. All rights reserved.
//

import UIKit
import CoreData
import BSImagePicker
import Alamofire
import Photos

class AddAlbumViewController: UIViewController {

    //Outlets
    
  
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var TxtFieldAlbumTitle: UITextField!
    @IBOutlet weak var LblImagesCounter: UILabel!
    
    ///////////////
    var Albums = [Album]()
    let AlbumsViewControllerVC = AlbumsViewController()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    typealias failureBlock = (AnyObject , Bool)->()
     typealias completionBlock = (AnyObject , Bool)->()

    //////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ActivityIndicator.isHidden = true

    }
    @objc func willEnterForeground() {
        self.LblImagesCounter.text = "\(PhotoArray.count) choosen Images"
        self.ActivityIndicator.isHidden = true

    }
 
    override func viewWillAppear(_ animated: Bool) {
        self.ActivityIndicator.isHidden = true

    }
    //////////
    
    func showImageCount (){
        DispatchQueue.main.async {
            self.LblImagesCounter.text = "\(self.SelectedAssets.count) choosen Images"
            self.ActivityIndicator.stopAnimating()
            self.ActivityIndicator.isHidden = true
        }
        
    }
    
    func showActivityInicator(){
        DispatchQueue.main.async {
            // self.ActivityIndicator.isHidden = false
            self.ActivityIndicator.startAnimating()
        }
      
    }
    
    
    /////////
    
    //ButtonsFuctions
    
    @IBAction func BtnActImportPhotos(_ sender: Any) {
        self.SelectedAssets.removeAll()
        self.PhotoArray.removeAll()
        PickImages { (DonePicking) in
            if DonePicking {
                DispatchQueue.main.async {
                    self.showActivityInicator()
                    self.showImageCount()
                }
                
            }
        }
        print (PhotoArray.count)
        
    }
    
    @IBAction func BtnActCreateAlbum(_ sender: Any) {
        
        var validateImageCount : Bool = false
        var validateExsitTitle : Bool = false
        var validateNewTitle : Bool = false
        let AlbumTitle = self.TxtFieldAlbumTitle.text!
                ///////////
        if !(Albums.isEmpty){
            ////
            for album in self.Albums {
                if  AlbumTitle == album.title {
                    self.LblImagesCounter.isHidden = false
                    self.LblImagesCounter.text = "Choose Another Album Title"
                    validateNewTitle = false
                    break
                }else{
                    validateNewTitle = true
                }
            }
       ////
        }else{
            validateNewTitle = true
        }
                /////////
                if  self.PhotoArray.count == 0   {
                    self.LblImagesCounter.text = "No Images Selected"
                    validateImageCount = false
                }else{
                    validateImageCount = true
                }
                /////////
                if  AlbumTitle == "" {
                    self.LblImagesCounter.isHidden = false
                    self.LblImagesCounter.text = "Choose Album Title"
                    validateExsitTitle = false
                }else{
                    validateExsitTitle = true
                }
           
                
                ///////////// Validate Before Save And Upload
                
                if validateExsitTitle == true && validateImageCount == true && validateNewTitle == true {
                    print("EnterValidatorOkay")
                    self.showActivityInicator()
                   
                    DispatchQueue.main.async {
                        self.save(completion: { (complete) in
                            if complete {
                                print("Saved To CoreData")
                            }
                        })
                        for image in self.PhotoArray{
                            self.uploadWithAlamofire(imageToUpload: image , completionUpload: { (finishedUpload) in
                                if finishedUpload {
                                    
                                    
                                    self.ActivityIndicator.stopAnimating()
                                    self.ActivityIndicator.isHidden = true
                                    self.LblImagesCounter.text = "Album Saved"
                                    self.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                            })
                        }
                        
                      
                        
                        
                    }
                 
                    }

            }
    
    ////////////////////
    
    func PickImages(completionPicking : @escaping (_ finishedPicking: Bool) -> ()) {
   
        // create an instance
        let vc = BSImagePickerViewController()
        
        //display picture gallery
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
         
            self.SelectedAssets.removeAll()
            self.PhotoArray.removeAll()

        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            DispatchQueue.main.async {
                self.showActivityInicator()
            }
            
         
            for i in 0..<assets.count
            {
            self.SelectedAssets.append(assets[i])
            }
             completionPicking(true)
            
            if self.SelectedAssets.count == 0{
            }else{
                self.convertAssetToImages()

               
               /* self.showActivityInicator()
                self.convertAssetToImages()
                self.showImageCount()*/
            }
           
        }, completion: nil)
        
    }
    
        ///////////
        
        func convertAssetToImages() -> Void {
            
            if SelectedAssets.count != 0{
                
                for i in 0..<SelectedAssets.count{
                    
                    let manager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    var thumbnail = UIImage()
                    option.isSynchronous = true
                    
                    
                    manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                        thumbnail = result!
                        
                    })
                    
                    let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                    let newImage = UIImage(data: data!)
                    
                   
                    self.PhotoArray.append(newImage! as UIImage)
            }
        }
    }
    
   
   ///////////UploadImage
    
    func uploadWithAlamofire(imageToUpload :UIImage , completionUpload: @escaping (_ finishedUpload: Bool) -> ()) {
     
      let URl =  "http://api.lafarge-safety.code95.info/api/v1/upload-media/"
    
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(imageToUpload, 1) {
                multipartFormData.append(imageData, withName: "media", fileName: "file.png", mimeType: "image/png")
            }
        }, to: URl, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    completionUpload(true)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    ///////// save to CoreData Function
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let NewAlbum = Album(context: managedContext)
        
        NewAlbum.title = self.TxtFieldAlbumTitle.text
        
        let imageData = UIImagePNGRepresentation(PhotoArray[0])

        NewAlbum.previewImage = imageData
        
        var DataArray = [Data]()
        
        for image in PhotoArray {
            DataArray.append(UIImagePNGRepresentation(image)!)
        }
        NewAlbum.images = DataArray
        
        do {
            try managedContext.save()
            print("Successfully saved data.")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    ////////////
}
