//
//  CellSearch.swift
//  wassup
//
//  Created by MAC on 8/20/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellSearch: UITableViewCell {

    @IBOutlet weak var titleCate: UILabel!
    @IBOutlet weak var viewCheckIn: UIView!
    @IBOutlet weak var viewJoin: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var btnLeft: UILabel!
    @IBOutlet weak var btnRight: UILabel!
    @IBOutlet weak var imgBtnLeft: UIImageView!
    @IBOutlet weak var imgBtnRight: UIImageView!
    
    var cate = ObjectType.Event
    var id = ""
    var activeLeft = false
    var activeRight = false
    
    func initCell(data: Dictionary<String, AnyObject>) {
        titleCate.layer.cornerRadius = 10
        titleCate.clipsToBounds = true
        viewJoin.corner(0, border: 1, colorBorder: 0xE0E3E7)
        viewCheckIn.corner(0, border: 1, colorBorder: 0xE0E3E7)
        
        titleCate.text = (cate == ObjectType.Event) ? Localization("Sự kiện") : Localization("Địa điểm")
        if cate == ObjectType.Host {
            titleCate.backgroundColor = UIColor.fromRgbHex(0xDC5244)
        }
        name.text = data["name"] as? String
        
        if cate == ObjectType.Event {
            info.text = "\(CONVERT_STRING(data["attend_number"])) Tham Gia | \(CONVERT_STRING(data["checkin_number"])) Check In"
        } else {
            info.text = "\(CONVERT_STRING(data["follow_number"])) Tham Gia | \(CONVERT_STRING(data["checkin_number"])) Check In"
        }
        position.text = data["location"] as? String
        
        if CONVERT_STRING(data["endtime"]) != "" && CONVERT_STRING(data["starttime"]) != "" && data["starttime"] != nil {
            time.text = Date().printDateToDate(CONVERT_STRING(data["starttime"]), to: CONVERT_STRING(data["endtime"]))
        } else {
            
        }
        
        if data["image"] != nil {
            LazyImage.showForImageView(cover, url: data["image"]! as? String)
        }
        
        let gestureJoin = UITapGestureRecognizer(target: self, action: #selector(clickLeft))
        viewJoin.addGestureRecognizer(gestureJoin)
        
        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(clickRight))
        viewCheckIn.addGestureRecognizer(gestureRight)
        
        //init button
        btnLeft.text = Localization("Quan Tâm")
        if cate == ObjectType.Host {
            btnLeft.text = Localization("Follow")
        }
        
        id = CONVERT_STRING(data["id"])
        
        let isAttend = CONVERT_BOOL(data["is_attend"])
        let isFollow = CONVERT_BOOL(data["is_follow"])
        if isAttend || isFollow {
            imgBtnLeft.image = UIImage(named: "ic_join_selected")
            activeLeft = true
            btnLeft.text = Localization("Đã quan tâm")
        }
        
        let isCheckin = CONVERT_BOOL(data["is_checkin"])
        if isCheckin {
            imgBtnRight.image = UIImage(named: "ic_checkin_selected")
            activeRight = true
        }
    }
    
    @IBAction func clickLeft(sender: AnyObject) {
        activeLeft = !activeLeft
        if activeLeft {
            imgBtnLeft.image = UIImage(named: "ic_join_selected")
            btnLeft.text = Localization("Đã quan tâm")
        } else {
            imgBtnLeft.image = UIImage(named: "ic_join_normal")
            btnLeft.text = Localization("Quan Tâm")
        }
        let md = User()
        if cate == ObjectType.Event {
            md.registEvent(id)
        } else {
            md.followHost(id)
        }
    }
    
    @IBAction func clickRight(sender: AnyObject) {
        activeRight = !activeRight
        if activeRight {
            imgBtnRight.image = UIImage(named: "ic_checkin_selected")
        } else {
            imgBtnRight.image = UIImage(named: "ic_checkin_normal")
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
