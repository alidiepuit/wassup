//
//  InfoMarker.swift
//  wassup
//
//  Created by MAC on 8/19/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class InfoMarker: UIView {
    var contentView:UIView?
    // other outlets
    
    @IBOutlet weak var btnCheckIn: UIView!
    @IBOutlet weak var btnFollow: UIView!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var icCheckIn: UIImageView!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var icFollow: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    var id = ""
    var activeLeft = false
    var activeRight = false
    var cate = ObjectType.Event
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        contentView = self.loadViewFromNib("InfoMarker")
        contentView!.frame = self.bounds
        contentView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(contentView!)
        
        btnFollow.corner(0, border: 1, colorBorder: 0xE0E3E7)
        btnCheckIn.corner(0, border: 1, colorBorder: 0xE0E3E7)
        
        let gestureJoin = UITapGestureRecognizer(target: self, action: #selector(clickLeft))
        btnFollow.addGestureRecognizer(gestureJoin)
        
        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(clickRight))
        btnCheckIn.addGestureRecognizer(gestureRight)
    }
    
    func initData(data:Dictionary<String,String>) {
        id = data["id"]!
        LazyImage.showForImageView(cover, url: data["image"])
        lblLocation.text = data["location"]
        lblTime.text = Date().printDateToDate(data["starttime"]!, to: data["endtime"]!)
        name.text = data["name"]
        info.text = "\(CONVERT_INT(data["attend_number"])) \(Localization("Quan Tâm")) | \(CONVERT_INT(data["hits"])) \(Localization("Check In"))"
        
        icFollow.image = UIImage(named: "ic_join_normal")
        lblFollow.text = Localization("Quan Tâm")
        
        getDetailEvent(id)
    }
    
    @IBAction func clickLeft(sender: AnyObject) {
        activeLeft = !activeLeft
        if activeLeft {
            icFollow.image = UIImage(named: "ic_join_selected")
            lblFollow.text = Localization("Đã quan tâm")
        } else {
            icFollow.image = UIImage(named: "ic_join_normal")
            lblFollow.text = Localization("Quan Tâm")
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
            icCheckIn.image = UIImage(named: "ic_checkin_selected")
        } else {
            icCheckIn.image = UIImage(named: "ic_checkin_normal")
        }
    }
    
    func getDetailEvent(id: String) {
        let md = Search()
        md.getDetailEvent(id) {
            (result: AnyObject?) in
            let data = result!["event"] as! Dictionary<String,AnyObject>
            let isAttend = CONVERT_BOOL(data["is_attend"])
            self.activeLeft = isAttend
            if isAttend {
                self.icFollow.image = UIImage(named: "ic_join_selected")
                self.lblFollow.text = Localization("Đã quan tâm")
            } else {
                self.icFollow.image = UIImage(named: "ic_join_normal")
                self.lblFollow.text = Localization("Quan Tâm")
            }
        }
    }
}
