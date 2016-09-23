//
//  CommentController.swift
//  wassup
//
//  Created by MAC on 9/19/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Fusuma

class CommentController: UIViewController {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var constraintHeightComment: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightImages: NSLayoutConstraint!
    @IBOutlet weak var images: UICollectionView!
    @IBOutlet weak var content: UIPlaceHolderTextView!
    @IBOutlet weak var scroll: UIScrollView!
    
    var listImages = [CellImage]()
    var cate = ObjectType.Event
    var data:Dictionary<String,AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData(data)
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
    
        Utils.loadImage(avatar, link: CONVERT_STRING(data["image"]))
        
        images.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deselectImageComment(_:)), name: "DESELECT_IMAGE_COMMENT", object: nil)
        
        content.placeholder = Localization("What's on your mind?")
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyboard(_:)))
        self.view.addGestureRecognizer(ges)
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
    
    @IBAction func clickCamera(sender: AnyObject) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func deselectImageComment(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String,AnyObject>
        let indexPath = d["indexPath"] as! NSIndexPath
        listImages = listImages.filter() {
            let i = $0 as CellImage
            return i.indexPath != indexPath
        }
        images.reloadData()
    }
    
    @IBAction func saveComment(sender: AnyObject) {
        let description = content.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if description == "" {
            return
        }
        
        Utils.lock()
        var arrImage = [UIImage]()
        for i in listImages {
            arrImage.append(i.image!)
        }
        let md = User()
        md.comment(cate, id: CONVERT_STRING(data["id"]), description: description, images: arrImage) {
            (result:AnyObject?) in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension CommentController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellImage", forIndexPath: indexPath) as! CellImage
        cell.img.image = listImages[indexPath.row].image
        cell.indexPath = indexPath
        cell.btnClose.hidden = false
        return cell
    }
}

extension CommentController: FusumaDelegate {
    func fusumaImageSelected(image: UIImage) {
        let cell = CellImage()
        cell.image = image
        cell.indexPath = NSIndexPath(forRow: listImages.count, inSection: 0)
        listImages.append(cell)
        
        let lastIndexPath = NSIndexPath(forRow: listImages.count - 1, inSection: 0)
        images.insertItemsAtIndexPaths([lastIndexPath])
        
        constraintHeightImages.constant = ((CGFloat(listImages.count) + 2) / 3) * 200
        scroll.contentSize = CGSize(width: scroll.contentSize.width, height: content.frame.size.height + constraintHeightImages.constant)
        scroll.updateConstraintsIfNeeded()
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
}

extension CommentController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let text = textView.text
        let hei = text.heightWithConstrainedWidth(content.frame.size.width, font: UIFont(name: "Helvetica Neue", size: 14.0)!) + 20
        constraintHeightComment.constant = hei < 80 ? 80 : hei
        scroll.updateConstraints()
    }
}