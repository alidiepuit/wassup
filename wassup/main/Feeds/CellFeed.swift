//
//  CellFeed.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import AlamofireImage

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
    @IBOutlet weak var constraintHeightImage: NSLayoutConstraint!
    @IBOutlet weak var lblComment: UITextView!
    @IBOutlet weak var lblBookmark: UILabel!
    @IBOutlet weak var lblLike: UILabel!
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
    var showCover = true
    var images = [SKPhoto]()
    var numLike = 0
    
    func initCell(data: Dictionary<String, AnyObject>) {
        Utils.loadImage(avatar, link: CONVERT_STRING(data["user_image"]))
        
        lblTimeAgo.text = CONVERT_STRING(data["time_ago"])
        
        id = CONVERT_STRING(data["id"])
        userId = CONVERT_STRING(data["user_id"])
        
        avatar.corner(24, border: 0, colorBorder: 0x000000)
        
        if let item = data["item"] as? Dictionary<String, AnyObject> {
        
            let objectType = CONVERT_INT(data["object_type"])
            
            if objectType == ObjectType.Event.rawValue || objectType == ObjectType.UserRegistEvent.rawValue {
                if CONVERT_STRING(item["endtime"]) != "" && CONVERT_STRING(item["starttime"]) != "" {
                    lblTime.text = Date().printDateToDate(CONVERT_STRING(item["starttime"]), to: CONVERT_STRING(item["endtime"]))
                } else {
                    
                }
            } else if objectType == ObjectType.Host.rawValue || objectType == ObjectType.Checkin.rawValue {
                lblTime.text = Date().printTimeOpen(CONVERT_STRING(item["starttime"]), to: CONVERT_STRING(item["endtime"]))
            }
            
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
            var status = String.init(format: Localization(format), name, event)
            
            //check object type
            if objectType == ObjectType.Checkin.rawValue {
                format = ActivityType.Checkin.rawValue
                status = String.init(format: Localization(format), name, event)
                if activity != "" {
                    format = ActivityType.CheckinHasFeeling.rawValue
                    status = String.init(format: Localization(format), name, activity, event)
                }
            } else if objectType == ObjectType.Comment.rawValue {
                format = ActivityType.Comment.rawValue
                status = String.init(format: Localization(format), name, event)
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
            lblStatus.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.fromRgbHex(0x4A90E2)]
            
            lblComment.text = CONVERT_STRING(item["comment"])
            if lblComment.text == "" {
                constraintComment.constant = 0
            } else {
                constraintComment.constant = lblComment.text.heightWithConstrainedWidth(lblComment.frame.size.width, font: UIFont(name: "Helvetica Neue", size: 14)!)
            }
            
            btnLeft.corner(0, border: 1, colorBorder: 0xE0E3E7)
            btnRight.corner(0, border: 1, colorBorder: 0xE0E3E7)
            
            if item["starttime"] != nil && item["endtime"] != nil {
                lblTime.text = Date().printDateToDate(CONVERT_STRING(item["starttime"]), to: CONVERT_STRING(item["endtime"]))
            }
            let location = CONVERT_STRING(item["location"])
            if location != "" && showCover {
                lblLocation.text = CONVERT_STRING(item["location"])
                containerLocation.hidden = false
                constraintLocation.constant = 77
            } else {
                constraintLocation.constant = 0
                containerLocation.hidden = true
            }
            
            listImage = [String]()
            constraintHeightImage.constant = 173
            let l = item["images"] as? [String]
            if l != nil && l!.count > 0 {
                listImage = l!
                collectionImage.scrollEnabled = true
            } else if showCover {
                listImage = [CONVERT_STRING(item["image"])]
                collectionImage.scrollEnabled = false
            } else {
                constraintHeightImage.constant = 0
            }
            images.removeAll()
            for img in listImage {
                let photo = SKPhoto.photoWithImageURL(img)
                images.append(photo)
            }
            
            if images.count > 0 {
                collectionImage.reloadData()
                collectionImage.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
            }
            
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
                lblBookmark.text = Localization("Đã lưu")
                activeLeft = true
            } else {
                imgBtnLeft.image = UIImage(named: "ic_bookmark")
                lblBookmark.text = Localization("Lưu lại")
            }
            
            let isCheckin = CONVERT_BOOL(data["is_like"])
            activeRight = false
            if isCheckin {
                imgBtnRight.image = UIImage(named: "ic_love_enable")
                activeRight = true
            } else {
                imgBtnRight.image = UIImage(named: "ic_love")
            }
            
            numLike = CONVERT_INT(data["like"])
            if numLike > 0 {
                lblLike.text = String.init(format: "%@ (%d)", Localization("Thích"), numLike)
            } else {
                lblLike.text = Localization("Thích")
            }
            
            let gestureJoin = UITapGestureRecognizer(target: self, action: #selector(clickLeft))
            btnLeft.addGestureRecognizer(gestureJoin)
            
            let gestureRight = UITapGestureRecognizer(target: self, action: #selector(clickRight))
            btnRight.addGestureRecognizer(gestureRight)
        } else {
            btnLeft.hidden = true
            btnRight.hidden = true
            
            let objectType = CONVERT_INT(data["object_type"])
            let name = CONVERT_STRING(data["fullname"])
            let event = CONVERT_STRING(data["name"])
            var format = ActivityType.PostActivity.rawValue
            var status = String.init(format: format, name, event)

            //check object type
            if objectType == ObjectType.Article.rawValue {
                format = ActivityType.PostArticle.rawValue
                status = String.init(format: format, name, event)
            }
            
            let attribute = [ NSFontAttributeName: UIFont(name: "Helvetica", size: 14.0)! ]
            let mutableString = NSMutableAttributedString(string: status, attributes: attribute)
            rangeProfile = NSRange(location:0,length:name.characters.count)
            mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: rangeProfile)
            rangeDetailEvent = NSRange(location:status.characters.count-event.characters.count,length:event.characters.count)
            mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.fromRgbHex(0x4A90E2), range: rangeDetailEvent)
            
            lblStatus.attributedText = mutableString
            let date = Date()
            let formatDate = NSDateFormatter()
            formatDate.dateFormat = "dd M yyyy"
            date.formatOutput = formatDate
            lblTimeAgo.text = date.print(CONVERT_STRING(data["created_at"]))
            
            lblComment.text = CONVERT_STRING(data["description"])
            if lblComment.text == "" {
                constraintComment.constant = 0
            } else {
                constraintComment.constant = lblComment.text.heightWithConstrainedWidth(lblComment.frame.size.width, font: UIFont(name: "Helvetica Neue", size: 14)!)
            }
            
            listImage = [CONVERT_STRING(data["image"])]
            collectionImage.reloadData()
            collectionImage.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
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
    
    @IBAction func clickLeft(sender: AnyObject) {
        if !activeLeft {
            NSNotificationCenter.defaultCenter().postNotificationName("CLICK_BOOKMARK_ON_FEED", object: nil, userInfo: ["indexPath":indexPath])
        }
    }
    
    @IBAction func clickRight(sender: AnyObject) {
        if !activeRight {
            activeRight = !activeRight
            numLike += 1
            NSNotificationCenter.defaultCenter().postNotificationName("CLICK_LIKE_ON_FEED", object: nil, userInfo: ["indexPath":indexPath,
            "like": numLike,
                "is_like": activeRight])
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("POST_MESSAGE_FROM_FEED", object: nil, userInfo: ["msg":Localization("Bạn đã thích bài viết này")])
        }
    }
}

extension CellFeed: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellImage", forIndexPath: indexPath) as! CellImage
        Utils.loadImage(cell.img, link: listImage[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if listImage.count == 1 {
            return CGSizeMake(collectionView.bounds.size.width, CGFloat(collectionView.bounds.size.height-10))
        }
        return CGSizeMake(collectionView.bounds.size.height, CGFloat(collectionView.bounds.size.height-10))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if listImage.count == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName("CLICK_STATUS_GO_TO_DETAIL_EVENT_ON_FEED", object: nil, userInfo: ["indexPath":self.indexPath])
            return
        }
        print("click photo at index", indexPath.row)
        NSNotificationCenter.defaultCenter().postNotificationName("BROWSER_PHOTOS_ON_FEED", object: nil, userInfo: ["index":indexPath.row, "images": images])
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
