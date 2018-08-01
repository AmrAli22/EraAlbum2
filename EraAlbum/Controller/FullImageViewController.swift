//
//  FullImageViewController.swift
//  Albumera
//
//  Created by Amr Ali on 7/23/18.
//  Copyright © 2018 TheAmrAli. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  
    ////////////////
    
    var collectionView : UICollectionView!
    var ImageArray = [UIImage]()
    var  SenderIndex = IndexPath()
    
    /////

    override func viewWillLayoutSubviews() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else{return}

        flowLayout.itemSize = collectionView.frame.size
        flowLayout.invalidateLayout()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = collectionView.contentOffset
        let width = collectionView.bounds.size.width
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width , y: offset.y)
        
        collectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            
             self.collectionView.reloadData()
            self.collectionView.setContentOffset(newOffset, animated: false)
       
        }, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(SenderIndex.item)
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
         let Layout  = UICollectionViewFlowLayout()
        Layout.scrollDirection = .horizontal
        Layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        Layout.minimumInteritemSpacing = 0
        Layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: Layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FullImageCell.self , forCellWithReuseIdentifier: "Cell")
        collectionView.isPagingEnabled = true
        collectionView.cellForItem(at: SenderIndex)
        
        self.view.addSubview(collectionView)
        
        collectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) |
            UInt8(UIViewAutoresizing.flexibleHeight.rawValue)
        ))
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.scrollToItem(at: SenderIndex , at: .left , animated: true)

    }
    
    
    
    
    ////
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FullImageCell
        cell?.ImgView.image = ImageArray[indexPath.row]
        return cell!
    }
}


class FullImageCell : UICollectionViewCell , UIScrollViewDelegate {
    
    
    var ScrollImage = UIScrollView()
    var ImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        
        ScrollImage = UIScrollView()
        ScrollImage.delegate = self
        ScrollImage.showsVerticalScrollIndicator = true
        ScrollImage.alwaysBounceHorizontal = false
        ScrollImage.alwaysBounceVertical = false
        ScrollImage.flashScrollIndicators()
        ScrollImage.minimumZoomScale = 1.0
        ScrollImage.maximumZoomScale = 4.0

        
        
        let TabGest = UITapGestureRecognizer(target: self, action: #selector(HandleDoubleTabRecognizer(recognizer:)))
        TabGest.numberOfTapsRequired = 2
        ScrollImage.addGestureRecognizer(TabGest)
        
        self.addSubview(ScrollImage)
      
        ImgView = UIImageView()
        ImgView.image = UIImage(named: "BluePond")
        ScrollImage.addSubview(ImgView)
        ImgView.contentMode = .scaleAspectFit
        
    }
    
     @objc  func HandleDoubleTabRecognizer(recognizer: UITapGestureRecognizer){
    
        if ScrollImage.zoomScale == 1 {
            ScrollImage.zoom(to: zoomRectForScale(scale: ScrollImage.maximumZoomScale , Center: recognizer.location(in: recognizer.view)) , animated: true)
            
        }else{
            ScrollImage.setZoomScale(1.0, animated: true) 
        }
    }
    
    func zoomRectForScale(scale:CGFloat,Center:CGPoint) -> CGRect {
        var ZoomRect = CGRect.zero
        ZoomRect.size.height = ImgView.frame.size.height / scale
        ZoomRect.size.width = ImgView.frame.size.width / scale
        
        let newCenter = ImgView.convert(Center, from: ScrollImage)
         ZoomRect.origin.x = newCenter.x - (ZoomRect.size.width / 2.0)
         ZoomRect.origin.y = newCenter.y - (ZoomRect.size.height / 2.0)
        
        return ZoomRect
     
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ImgView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ScrollImage.setZoomScale(1, animated: true)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        ImgView.frame = self.bounds
        ScrollImage.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
