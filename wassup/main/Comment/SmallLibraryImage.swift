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
    var images = [UIImage]()
    var totalImageCountNeeded = 7
    
    let pickerController = DKImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerNib(UINib(nibName: "CellLibrary", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.collectionViewLayout = CustomImageFlowLayout()
        
        fetchPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellLibrary
        
        //first or last cell
        if indexPath.row == 0 || indexPath.row == self.images.count-1 {
            cell.image.hidden = true
            cell.icon.hidden = false
        } else {
            cell.image.hidden = false
            cell.icon.hidden = true
        }
        
        cell.icon.image = self.images[indexPath.row]
        cell.image.image = self.images[indexPath.row]
        
        cell.bg.hidden = true
        
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
            pickerController.sourceType = .Camera
            self.presentViewController(pickerController, animated: true) {}
            break
        case images.count-1:
            //chose from library
            pickerController.sourceType = .Photo
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                print("didSelectAssets")
                print(assets)
            }
            self.presentViewController(pickerController, animated: true) {}
            break
        default:
            return
        }
    }
 
    func fetchPhotos() {
        self.addImgToArray(UIImage(named: "ic_camera")!)
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
        var requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        var fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.addImgToArray(image!)
                    
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                    } else {
                        self.addImgToArray(UIImage(named: "ic_library")!)
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
    }
    
    func addImgToArray(uploadImage:UIImage) {
        self.images.append(uploadImage)
    }
}
