//
//  CellProfileHeaderPhoto.swift
//  wassup
//
//  Created by MAC on 9/12/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class CellProfileHeaderPhoto: UITableViewCell {

    @IBOutlet weak var selectTypeFeed: UISegmentedControl!
    @IBOutlet weak var constrain: NSLayoutConstraint!
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var collection: UICollectionView!
    var listImage = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
    }
    
    func initData(data: Dictionary<String,AnyObject>) {
        listImage = data["photos"] as! [String]
        if listImage.count > 0 {
            collection.reloadData()
        } else {
            viewPhoto.removeFromSuperview()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickTypeFeed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("CHANGE_TYPE_FEED_PROFILE", object: nil, userInfo: ["typeFeed": selectTypeFeed.selectedSegmentIndex])
    }
}

extension CellProfileHeaderPhoto: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCellWithReuseIdentifier("CellImage", forIndexPath: indexPath) as! CellImage
        LazyImage.showForImageView(cell.img, url: listImage[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("SHOW_BROWSER_IMAGE", object: nil, userInfo: ["index": indexPath.row])
    }
}