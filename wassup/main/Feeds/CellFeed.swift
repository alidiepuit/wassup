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
    @IBOutlet weak var lblStatus: UITextView!
    @IBOutlet weak var containerLocation: UIView!
    @IBOutlet weak var constraintLocation: NSLayoutConstraint!
    @IBOutlet weak var constraintComment: NSLayoutConstraint!
    @IBOutlet weak var lblComment: UITextView!
    
    @IBOutlet weak var imgBtnRight: UIImageView!
    @IBOutlet weak var imgBtnLeft: UIImageView!
    var listImage = [String]()
    var listTags = [Dictionary<String,String>]()
    var activeLeft = false
    var activeRight = false
    var id = ""
    var userId = ""
    var indexPath = NSIndexPath(index: 0)
    var rangeProfile = NSRange()
    var rangeDetailEvent = NSRange()
    
    func initCell(data: Dictionary<String, AnyObject>) {
        if CONVERT_STRING(data["user_image"]) != "" {
            LazyImage.showForImageView(avatar, url: CONVERT_STRING(data["user_image"]))
        } else {
            avatar.image = UIImage(named: "avatar_default")
        }
        
        lblTimeAgo.text = CONVERT_STRING(data["time_ago"])
        
        let item = data["item"] as! Dictionary<String, AnyObject>
        
        id = CONVERT_STRING(data["id"])
        userId = CONVERT_STRING(data["user_id"])
        if CONVERT_STRING(item["endtime"]) != "" && CONVERT_STRING(item["starttime"]) != "" {
            lblTime.text = Date().printDateToDate(CONVERT_STRING(item["starttime"]), to: CONVERT_STRING(item["endtime"]))
        } else {
            
        }
        
        let objectType = CONVERT_INT32(data["object_type"])
        let name = CONVERT_STRING(data["email"])
        let event = CONVERT_STRING(item["title"])
        var feelings = Dictionary<String,AnyObject>()
        if let feel = item["feelings"] as? Dictionary<String,AnyObject> {
            feelings = feel
        }
        
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
        
        let attribute = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 14.0)! ]
        let mutableString = NSMutableAttributedString(string: status, attributes: attribute)
        rangeProfile = NSRange(location:0,length:name.characters.count)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: rangeProfile)
        rangeDetailEvent = NSRange(location:status.characters.count-event.characters.count,length:event.characters.count)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: rangeDetailEvent)
        
        
        if objectType == ObjectType.Checkin.rawValue && activity != "" {
            mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: NSRange(location:name.characters.count + 6,length:activity.characters.count))
        }
        
        //event click profile, event
        mutableString.addAttribute(NSLinkAttributeName, value: id, range: rangeDetailEvent)
        mutableString.addAttribute(NSLinkAttributeName, value: userId, range: rangeProfile)
        
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
            constraintLocation.constant = 77
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
        
        viewlistTags.delegate = self
        if let _ = feelings["3"] as? [Dictionary<String,String>] {
            listTags = feelings["3"] as! [Dictionary<String,String>]
            viewlistTags.removeAllTags()
            for tag:Dictionary<String,String> in listTags {
                viewlistTags.addTag(tag["text_feeling"]!, id: tag["id"]!)
            }
            constraintListTags.constant = viewlistTags.intrinsicContentSize().height
            viewlistTags.hidden = false
        } else {
            constraintListTags.constant = 0
            viewlistTags.hidden = true
        }
        
        let isFollow = CONVERT_BOOL(data["is_bookmark"])
        activeLeft = false
        if isFollow {
            imgBtnLeft.image = UIImage(named: "ic_bookmark_enable")
            activeLeft = true
        } else {
            imgBtnLeft.image = UIImage(named: "ic_bookmark")
        }
        
        let isCheckin = CONVERT_BOOL(data["is_like"])
        activeRight = false
        if isCheckin {
            imgBtnRight.image = UIImage(named: "ic_love_enable")
            activeRight = true
        } else {
            imgBtnRight.image = UIImage(named: "ic_love")
        }
        
        let gestureJoin = UITapGestureRecognizer(target: self, action: #selector(clickLeft))
        btnLeft.addGestureRecognizer(gestureJoin)
        
        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(clickRight))
        btnRight.addGestureRecognizer(gestureRight)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickLeft(sender: AnyObject) {
        activeLeft = !activeLeft
        if activeLeft {
            imgBtnLeft.image = UIImage(named: "ic_bookmark_enable")
        } else {
            imgBtnLeft.image = UIImage(named: "ic_bookmark")
        }
    }
    
    @IBAction func clickRight(sender: AnyObject) {
        activeRight = !activeRight
        if activeRight {
            imgBtnRight.image = UIImage(named: "ic_love_enable")
        } else {
            imgBtnRight.image = UIImage(named: "ic_love")
        }
        let md = User()
        md.likeFeed(id)
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

extension CellFeed: UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        var intersection = NSIntersectionRange(rangeProfile, characterRange)
        if intersection.length == rangeProfile.length {
            NSNotificationCenter.defaultCenter().postNotificationName("CLICK_STATUS_GO_TO_PROFILE_ON_FEED", object: nil, userInfo: ["userId":userId])
        }
        intersection = NSIntersectionRange(rangeDetailEvent, characterRange)
        if intersection.length == rangeDetailEvent.length {
            NSNotificationCenter.defaultCenter().postNotificationName("CLICK_STATUS_GO_TO_DETAIL_EVENT_ON_FEED", object: nil, userInfo: ["indexPath":indexPath])
        }
        return false
    }
}

extension CellFeed: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        NSNotificationCenter.defaultCenter().postNotificationName("CLICK_TAG_ON_FEED", object: nil, userInfo: ["keyword":(tagView.titleLabel?.text)!])
    }
    
    func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
        
    }
    
}
