//
//  EditProfileController.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Fusuma

class EditProfileController: UIViewController {

    var profile:Dictionary<String, AnyObject>!
    var typeImage = "avatar"
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var btnChangeCover: UIButton!
    @IBOutlet weak var btnChangeAvatar: UIButton!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization("Thông tin cá nhân")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectImage), name: "PROFILE_SELECT_IMAGE", object: nil)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        name.text = CONVERT_STRING(profile["fullname"])
        email.text = CONVERT_STRING(profile["email"])
        city.text = CONVERT_STRING(profile["address"])
        
        Utils.loadImage(avatar, link: CONVERT_STRING(profile["image"]))
        Utils.loadImage(cover, link: CONVERT_STRING(profile["banner"]))
        
        avatar.corner(64, border: 0, colorBorder: 0x000000)
        
        profile["name"] = name.text!
        profile["city"] = city.text!
        profile["avatar"] = avatar.image
        profile["cover"] = cover.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickChangeAvatar(sender: AnyObject) {
        typeImage = "avatar"
        selectImage()
    }
    
    @IBAction func clickChangeCover(sender: AnyObject) {
        typeImage = "cover"
        selectImage()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if sender === btnSave {
            let n = self.name.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if n == "" {
                let alert = UIAlertView(title: Localization("Thông báo"), message: Localization("Tên không được rỗng"), delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return false
            }
            profile["name"] = name.text!
            profile["city"] = city.text!
            profile["email"] = email.text!
        }
        return true
    }
}

extension EditProfileController: FusumaDelegate {
    func selectImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(image: UIImage) {
        if typeImage == "cover" {
            cover.image = image
        } else {
            avatar.image = image
        }
        profile[typeImage] = image
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
}
