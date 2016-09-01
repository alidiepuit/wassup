//
//  DetailCheckInController.swift
//  wassup
//
//  Created by MAC on 9/1/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class DetailCheckInController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        collectionView.registerNib(UINib(nibName: "CheckInCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CheckInCollectionCell")
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSkip(sender: AnyObject) {
        let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset;
        
        //scroll to next cell
        collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
    }
    
}

extension DetailCheckInController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CheckInCollectionCell", forIndexPath: indexPath) as! CheckInCollectionCell
        cell.initData(indexPath.row)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, CGFloat(collectionView.bounds.size.height))
    }
}