//
//  CellBlog.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellBlog: UITableViewCell {
    
    @IBOutlet weak var titleCate: UILabel!
    @IBOutlet weak var viewCheckIn: UIView!
    @IBOutlet weak var viewJoin: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var imgBtnLeft: UIImageView!
    @IBOutlet weak var imgBtnRight: UIImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var lblBookmark: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    
    var activeLeft = false
    var activeRight = false
    var id = ""
    var data:Dictionary<String,AnyObject>!
    var indexPath:NSIndexPath!
    var numLike = 0
    
    @IBOutlet weak var constrainHeightContent: NSLayoutConstraint!
    
    func initCell(data: Dictionary<String, AnyObject>) {
        self.data = data
        
        titleCate.layer.cornerRadius = 10
        titleCate.clipsToBounds = true
        viewJoin.corner(0, border: 1, colorBorder: 0xE0E3E7)
        viewCheckIn.corner(0, border: 1, colorBorder: 0xE0E3E7)
        
        Utils.loadImage(cover, link: CONVERT_STRING(data["image"]))
        name.text = CONVERT_STRING(data["name"])
        let date = Date()
        let formatDate = NSDateFormatter()
        formatDate.dateFormat = "dd MMMM yyyy"
        date.formatOutput = formatDate
        info.text = "\(date.print(CONVERT_STRING(data["created_at"]))) | By: \(CONVERT_STRING(data["author"]))"
        content.text = CONVERT_STRING(data["short_description"])
        
        let hei = content.text.heightWithConstrainedWidth(self.frame.size.width-18, font: UIFont(name: "Helvetica", size: 14)!)
        constrainHeightContent.constant = hei
        
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
        viewJoin.addGestureRecognizer(gestureJoin)
        
        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(clickRight))
        viewCheckIn.addGestureRecognizer(gestureRight)
        
        id = CONVERT_STRING(data["id"])
    }
    
    @IBAction func clickLeft(sender: AnyObject) {
        activeLeft = !activeLeft
        if activeLeft {
        NSNotificationCenter.defaultCenter().postNotificationName("BOOKMARK_FROM_MAIN_VIEW", object: nil, userInfo: ["data": data,
                "indexPath": indexPath])
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
        md.likeBlog(id)
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
