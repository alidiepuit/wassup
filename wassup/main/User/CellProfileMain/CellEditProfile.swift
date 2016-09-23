//
//  CellEditProfile.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Fusuma

class CellEditProfile: UITableViewCell {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var btnChangeCover: UIButton!
    @IBOutlet weak var btnChangeAvatar: UIButton!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var profile:Dictionary<String,AnyObject>!
    var typeImage = "avatar"
    
    func initData(data: Dictionary<String,AnyObject>) {
        name.text = CONVERT_STRING(data["fullname"])
        email.text = CONVERT_STRING(data["email"])
        city.text = CONVERT_STRING(data["address"])
        
        Utils.loadImage(avatar, link: CONVERT_STRING(data["image"]))
        Utils.loadImage(cover, link: CONVERT_STRING(data["banner"]))
        
        avatar.corner(64, border: 0, colorBorder: 0x000000)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveProfile), name: "SAVE_PROFILE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveImage(_:)), name: "PROFILE_SAVE_IMAGE", object: nil)
    }
    
    func saveProfile() {
        Utils.lock()
        let md = User()
        let avatarData = avatar.image!
        let coverData = cover.image!
        md.updateProfile(name.text!, email: email.text!, address: city.text!, avatar: avatarData, cover: coverData) {
            (result:AnyObject?) in
            print(result)
        }
    }
    
    func saveImage(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String,AnyObject>
        if typeImage == "avatar" {
            avatar.image = d["image"] as? UIImage
        } else if typeImage == "cover" {
            cover.image = d["image"] as? UIImage
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
    
    @IBAction func clickChangeAvatar(sender: AnyObject) {
        typeImage = "avatar"
        NSNotificationCenter.defaultCenter().postNotificationName("PROFILE_SELECT_IMAGE", object: nil)
    }
    
    @IBAction func clickChangeCover(sender: AnyObject) {
        typeImage = "cover"
        NSNotificationCenter.defaultCenter().postNotificationName("PROFILE_SELECT_IMAGE", object: nil)
    }
}


