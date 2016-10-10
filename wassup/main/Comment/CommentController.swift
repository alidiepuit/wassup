//
//  CommentController.swift
//  wassup
//
//  Created by MAC on 9/19/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Fusuma
import DKImagePickerController

class CommentController: UIViewController {

    @IBOutlet weak var btnCancelCheckIn: UIButton!
    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var constrainBottomSwitch: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var constraintHeightComment: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightImages: NSLayoutConstraint!
    @IBOutlet weak var content: UIPlaceHolderTextView!
    @IBOutlet weak var scroll: UIScrollView!
    
    var cate = ObjectType.Event
    var data:Dictionary<String,AnyObject>!
    
    var saveData:Dictionary<String,AnyObject>!
    var smallLibrary: SmallLibraryImage!
    
    let pickerController = DKImagePickerController()
    
    var cateView = ObjectType.Checkin
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData(data)
        
        pickerController.assetType = .AllPhotos
    }
    
    func initData(data: Dictionary<String,AnyObject>) {
        name.text = CONVERT_STRING(data["name"])
        location.text = CONVERT_STRING(data["location"])
        if cate == ObjectType.Event {
            if CONVERT_STRING(data["endtime"]) != "" && CONVERT_STRING(data["starttime"]) != "" && data["starttime"] != nil {
                time.text = Date().printDateToDate(CONVERT_STRING(data["starttime"]), to: CONVERT_STRING(data["endtime"]))
            } else {
                
            }
        } else {
            time.text = Date().printTimeOpen(CONVERT_STRING(data["starttime"]), to: CONVERT_STRING(data["endtime"]))
        }
    
        if cate == ObjectType.Event {
            Utils.loadImage(avatar, link: CONVERT_STRING(data["image"]))
        } else {
            Utils.loadImage(avatar, link: CONVERT_STRING(data["image_profile"]))
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showPickerImage(_:)), name: "SHOW_PICKER_IMAGE", object: nil)
        
        content.placeholder = Localization("What's on your mind?")
        
//        let ges = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyboard(_:)))
//        self.view.addGestureRecognizer(ges)
        
        smallLibrary = SmallLibraryImage(nibName: "SmallLibraryImage", bundle: nil)
        smallLibrary.view.frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        btnCancelCheckIn.corner(10, border: 1, colorBorder: 0x2180FA)
        btnCheckIn.corner(10, border: 0, colorBorder: 0x000000)
        
        if cateView == ObjectType.Checkin {
            title = "Check in"
        } else {
            title = "Comment"
        }
        btnCheckIn.setTitle(title, forState: .Normal)
    }
    
    func showKeyboard(noti: NSNotification) {
        let userInfo = noti.userInfo!
        let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        constrainBottomSwitch.constant = keyboardHeight + 10
        btnSwitch.hidden = false
    }
    
    func hideKeyboard(noti: NSNotification) {
        constrainBottomSwitch.constant = 10
        btnSwitch.hidden = true
    }
    
    func hiddenKeyboard(gesture: UIGestureRecognizer) {
        content.resignFirstResponder()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPickerImage(noti: NSNotification) {
        let userInfo = noti.userInfo as! Dictionary<String,AnyObject>
        
        let typePicker = userInfo["typePicker"] as! Int
        pickerController.sourceType = .Camera
        //chose from library
        if typePicker == DKImagePickerControllerSourceType.Photo.rawValue {
            pickerController.sourceType = .Photo
            pickerController.selectedAssets = userInfo["selectedImages"] as! [DKAsset]
        }
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.smallLibrary.selectedImages = assets
        }
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if sender === btnSave {
            return self.postData()
        }
        return true
    }
    
    @IBAction func switchKeyboard(sender: AnyObject) {
        let btn = sender as! UIButton
        let tag = btn.tag
        if tag == 0 {
            content.inputView = smallLibrary.view
            btnSwitch.setImage(UIImage(named: "ic_keyboard"), forState: .Normal)
        } else {
            content.inputView = nil
            btnSwitch.setImage(UIImage(named: "ic_camera"), forState: .Normal)
        }
        
        content.reloadInputViews()
        btn.tag = 1 - tag
    }
    
    @IBAction func cancelCheckIn(sender: AnyObject) {
        content.resignFirstResponder()
    }
    
    @IBAction func postCheckin(sender: AnyObject) {
        if self.postData() {
            self.performSegueWithIdentifier("saveComment", sender: self)
        }
    }
    
    func postData() -> Bool {
        let description = content.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if description == "" {
            let alert = UIAlertView(title: Localization("Thông báo"), message: "Bạn chưa nhập bình luận", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return false
        }
        
        var arrImage = [UIImage]()
        for asset in smallLibrary.selectedImages {
            asset.fetchOriginalImage(true) {
                (image, info) in
                arrImage.append(image!)
            }
        }
        saveData = ["id": CONVERT_STRING(data["id"]),
                    "description": description,
                    "arrImage": arrImage,
                    "cate": cate.rawValue
        ]
        return true
    }
}