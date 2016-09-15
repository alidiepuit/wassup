//
//  Tags.swift
//  wassup
//
//  Created by MAC on 8/17/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class Tags: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var data = Array<Dictionary<String, AnyObject>>()
    var selectedTags = Array<String>()
    var countItem = 0
    var selectedItem:CellTags?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.collectionView?.allowsMultipleSelection = true
        loadData()
    }
    
    func loadData() {
        let mod = TagsModel()
        mod.getRecommandtionTags() {
            (result:AnyObject?) in
            if let res = result as? Dictionary<String, AnyObject> {
                self.data = res["tags"] as! Array<Dictionary<String, AnyObject>>
                self.collectionView?.reloadData()
            }
        }
    }
    
    @IBAction func submitTags(sender: AnyObject) {
        let md = TagsModel()
        md.saveRecommandtionTags(selectedTags) {
            (result:AnyObject?) in
            let dict = result as! Dictionary<String, AnyObject>
            let status = dict["status"] as? Int
//            let alert = UIAlertView(title: Localization("Thông báo"), message: dict["message"] as? String, delegate: nil, cancelButtonTitle: "OK")
            if status == 1 {
                User.sharedInstance.hasRecommandation = true
                self.performSegueWithIdentifier("afterRecommendation", sender: nil)
                self.removeFromParentViewController()
            }
//            alert.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellTags", forIndexPath: indexPath) as! CellTags
        
        let d = self.data[indexPath.row]
        LazyImage.showForImageView(cell.img, url: d["image"] as? String)
        cell.img.layer.cornerRadius = 10
        cell.img.clipsToBounds = true
        cell.name.text = d["tag"] as? String
        cell.id = d["id"] as? String
        cell.viewSelected.corner(10, border: 1, colorBorder: 0xFFFFFF)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CellTags
        cell.viewSelected.hidden = false
        selectedTags.append(cell.id!)
        countItem += 1
        if countItem >= 5 {
            btnSubmit.backgroundColor = UIColor.whiteColor()
            btnSubmit.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            btnSubmit.enabled = true
            btnSubmit.setTitle(Localization("Xong"), forState: .Normal)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CellTags
        if let foundIndex = selectedTags.indexOf((cell.id!)) {
            cell.viewSelected.hidden = true
            selectedTags.removeAtIndex(foundIndex)
            countItem -= 1
            if countItem < 5 {
                btnSubmit.backgroundColor = UIColor.fromRgbHex(0xAAAAAA)
                btnSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                btnSubmit.enabled = false
                btnSubmit.setTitle(Localization("Chọn 5"), forState: .Normal)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if DeviceType.IS_IPHONE_6 {
            return CGSize(width: 100, height: 100)
        }
        return CGSize(width: 120, height: 120)
    }
}
