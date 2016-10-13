//
//  SmallLibraryImage.swift
//  wassup
//
//  Created by MAC on 10/6/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController

private let reuseIdentifier = "CellLibrary"

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method
protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class SmallLibraryImage: UICollectionViewController {
    
    weak var delegate: KeyboardDelegate?
    var images = [DKAsset]()
    var selectedImages = [DKAsset]()
    var totalImageCountNeeded = 7
    var selectedIndex = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerNib(UINib(nibName: "CellLibrary", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.collectionViewLayout = CustomImageFlowLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.images.removeAll()
        self.collectionView?.reloadData()
        self.fetchPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count == 0 ? 0 : self.images.count + 2
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellLibrary
        
        //first or last cell
        
        cell.bg.hidden = true
        if indexPath.row == 0 || indexPath.row == self.images.count+1 {
            cell.image.hidden = true
            cell.icon.hidden = false
            cell.icon.image = indexPath.row == 0 ? UIImage(named: "ic_camera_white") : UIImage(named: "ic_library")
        } else {
            cell.image.hidden = false
            cell.icon.hidden = true
            
            let idx = indexPath.row - 1
            
            let asset = self.images[idx]
            let tag = idx + 1
            cell.tag = tag
            asset.fetchOriginalImage(true, completeBlock: { image, info in
                if cell.tag == tag {
                    cell.image.image = image
                    cell.icon.image = image
                }
            })
            
            if self.existedAsset(asset) {
                cell.bg.hidden = false
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.collectionView!.frame.size.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            //take a picture
            NSNotificationCenter.defaultCenter().postNotificationName("SHOW_PICKER_IMAGE", object: nil, userInfo: ["typePicker": DKImagePickerControllerSourceType.Camera.rawValue])
            break
        case images.count+1:
            //chose from library
            NSNotificationCenter.defaultCenter().postNotificationName("SHOW_PICKER_IMAGE", object: nil, userInfo: ["typePicker": DKImagePickerControllerSourceType.Photo.rawValue,
                "selectedImages": self.selectedImages])
            break
        default:
            let idx = indexPath.row - 1
            let asset = self.images[idx]
            if self.selectedIndex.contains(idx) {
                //remove from selected
                self.removeFromSelected(asset, index: idx)
            } else {
                //add to selected
                self.addToSelected(asset, index: idx)
            }
            self.collectionView?.reloadItemsAtIndexPaths([indexPath])
            return
        }
    }
    
    func fetchPhotos() {
        var idx = 0
        for asset in self.selectedImages {
            self.addAssetToArray(asset)
            self.selectedIndex.append(idx)
            idx += 1
        }
        self.view.lock()
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                let asset = fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset
                
                if self.existedAsset(DKAsset(originalAsset: asset)) {
                    if index + 1 < fetchResult.count {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                        return
                    }
                }
                
                self.addImgToArray(asset)
                if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                    self.fetchPhotoAtIndexFromEnd(index + 1)
                } else {
                    self.collectionView?.reloadData()
                }
            }
            self.view.unlock()
        }
    }
    
    func existedAsset(a: DKAsset) -> Bool {
        for asset in self.selectedImages {
            if asset.isEqual(a) {
                return true
            }
        }
        return false
    }
    
    func addImgToArray(uploadImage:PHAsset) {
        self.images.append(DKAsset(originalAsset: uploadImage))
    }
    
    func addAssetToArray(uploadImage:DKAsset) {
        self.images.append(uploadImage)
    }
    
    func removeFromSelected(asset: DKAsset, index idx: Int) {
        self.selectedImages = self.selectedImages.filter() {
            let a = $0 as DKAsset
            return !a.isEqual(asset)
        }
        
        self.selectedIndex = self.selectedIndex.filter() {
            let i = $0 as Int
            return i != idx
        }
    }
    
    func addToSelected(asset: DKAsset, index idx: Int) {
        self.selectedImages.append(asset)
        self.selectedIndex.append(idx)
    }
}
