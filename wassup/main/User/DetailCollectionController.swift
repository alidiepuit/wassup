//
//  DetailBookmarkController.swift
//  wassup
//
//  Created by MAC on 9/14/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailCollectionController: UICollectionViewController {

    var collectionId = ""
    var data = [Dictionary<String,AnyObject>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callAPI()
    }
    
    func callAPI() {
        if collectionId == "" {
            return
        }
        let md = Collection()
        md.getBookmarks(collectionId) {
            (result:AnyObject?) in
            let d = result!["bookmarks"] as! [Dictionary<String,AnyObject>]
            for a in d {
                self.data.append(a)
                let lastIndexPath = NSIndexPath(forRow: self.data.count - 1, inSection: 0)
                self.collectionView?.insertItemsAtIndexPaths([lastIndexPath])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.data.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellDetailCollection
        let d = data[indexPath.row]
        Utils.loadImage(cell.img, link: CONVERT_STRING(d["image"]))
        cell.content.text = CONVERT_STRING(d["description"])
        return cell
    }
}
