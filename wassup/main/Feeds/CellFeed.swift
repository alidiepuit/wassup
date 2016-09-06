//
//  CellFeed.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellFeed: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!

    @IBOutlet weak var constraintListTags: NSLayoutConstraint!
    @IBOutlet weak var viewlistTags: TagListView!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var btnRight: UIView!
    @IBOutlet weak var btnLeft: UIView!
    @IBOutlet weak var icLike: UIImageView!
    @IBOutlet weak var icSave: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var containerLocation: UIView!
    @IBOutlet weak var constraintLocation: NSLayoutConstraint!
    @IBOutlet weak var constraintComment: NSLayoutConstraint!
    @IBOutlet weak var lblComment: UITextView!
    
    var listImage = [String]()
    var listTags = [Dictionary<String,String>]()
    
    func initCell(data: Dictionary<String, AnyObject>) {
        LazyImage.showForImageView(avatar, url: CONVERT_STRING(data["user_image"]))
        lblTimeAgo.text = CONVERT_STRING(data["time_ago"])
        
        let item = data["item"] as! Dictionary<String, AnyObject>
        
        if CONVERT_STRING(item["endtime"]) != "" && CONVERT_STRING(item["starttime"]) != "" {
            lblTime.text = Date().printDateToDate(CONVERT_STRING(item["starttime"]), to: CONVERT_STRING(item["endtime"]))
        } else {
            
        }
        
        let objectType = CONVERT_INT32(data["object_type"])
        let name = CONVERT_STRING(data["email"])
        let event = CONVERT_STRING(item["title"])
        let feelings = item["feelings"] != nil ? item["feelings"] as! Dictionary<String,AnyObject> : Dictionary<String,AnyObject>()
        
        var activity = ""
        if feelings.count > 0 && feelings["1"] != nil {
            let a = feelings["1"] as! [Dictionary<String,AnyObject>]
            activity = CONVERT_STRING(a[0]["text_feeling"])
        }
        
        var format = ActivityType.UserRegistEvent.rawValue
        var status = String.init(format: format, name, event)
        
        //check object type
        if objectType == ObjectType.Checkin.rawValue {
            format = ActivityType.Checkin.rawValue
            status = String.init(format: format, name, event)
            if activity != "" {
                format = ActivityType.CheckinHasFeeling.rawValue
                status = String.init(format: format, name, activity, event)
            }
        } else if objectType == ObjectType.Comment.rawValue {
            format = ActivityType.Comment.rawValue
            status = String.init(format: format, name, event)
        }
        
        let mutableString = NSMutableAttributedString(string: status)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: NSRange(location:0,length:name.characters.count))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: NSRange(location:status.characters.count-event.characters.count,length:event.characters.count))
        
        if objectType == ObjectType.Checkin.rawValue && activity != "" {
            mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: NSRange(location:name.characters.count + 6,length:activity.characters.count))
        }
        
        lblStatus.attributedText = mutableString
        lblComment.text = CONVERT_STRING(item["comment"])
        if lblComment.text == "" {
            constraintComment.constant = 0
        } else {
            constraintComment.constant = lblComment.text.heightWithConstrainedWidth(lblComment.frame.size.width, font: UIFont(name: "Helvetica", size: 14)!)
        }
        
        avatar.corner(24, border: 0, colorBorder: 0x000000)
        btnLeft.corner(0, border: 1, colorBorder: 0xE0E3E7)
        btnRight.corner(0, border: 1, colorBorder: 0xE0E3E7)
        
        if item["starttime"] != nil && item["endtime"] != nil {
            lblTime.text = Date().printDateToDate(CONVERT_STRING(item["starttime"]), to: CONVERT_STRING(item["endtime"]))
        }
        if item["location"] != nil {
            lblLocation.text = CONVERT_STRING(item["location"])
            containerLocation.hidden = false
        } else {
            constraintLocation.constant = 0
            containerLocation.hidden = true
        }
        
        if let l = item["images"] as? [String] {
            listImage = l
        } else {
            listImage = [CONVERT_STRING(item["image"])]
        }
        collectionImage.reloadData()
        collectionImage.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
        
        if let _ = feelings["3"] as? [Dictionary<String,String>] {
            listTags = feelings["3"] as! [Dictionary<String,String>]
            viewlistTags.removeAllTags()
            for tag:Dictionary<String,String> in listTags {
                viewlistTags.addTag(tag["text_feeling"]!, id: tag["id"]!)
            }
            constraintListTags.constant = 45 * CGFloat(viewlistTags.rows)
            viewlistTags.hidden = false
        } else {
            constraintListTags.constant = 0
            viewlistTags.hidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellFeed: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellImage", forIndexPath: indexPath) as! CellImage
        LazyImage.showForImageView(cell.img, url: listImage[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if listImage.count == 1 {
            return CGSizeMake(collectionView.bounds.size.width, CGFloat(collectionView.bounds.size.height))
        }
        return CGSizeMake(collectionView.bounds.size.height, CGFloat(collectionView.bounds.size.height))
    }
}
