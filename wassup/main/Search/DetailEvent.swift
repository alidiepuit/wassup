//
//  DetailEvent.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import GoogleMaps
import SKPhotoBrowser

class DetailEvent: UITableViewCell {
    @IBOutlet weak var content: UIWebView!
    
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblNumberView: UILabel!
    @IBOutlet weak var lblNumberFollow: UILabel!
    @IBOutlet weak var lblNumberCheckin: UILabel!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var maps: GMSMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var album: UICollectionView!
    
    @IBOutlet weak var constraintContent: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightTagList: NSLayoutConstraint!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var constraintHeightViewTime: NSLayoutConstraint!
    
    var cate = ObjectType.Event
    var id = ""
    var activeLeft = false
    var activeRight = false
    
    var listImage:Array<String> = []
    var listTags = [Dictionary<String,String>]()
    
    var observing = false
    var MyObservationContext = 0
    
    deinit {
        stopObservingHeight()
    }
    
    func initData(data:Dictionary<String,AnyObject>) {
        if cate == ObjectType.Event {
            Utils.loadImage(cover, link: CONVERT_STRING(data["image"]))
        } else {
            Utils.loadImage(cover, link: CONVERT_STRING(data["image_profile"]))
        }
        btnLeft.corner(20, border: 0, colorBorder: 0x000000)
        btnRight.corner(20, border: 0, colorBorder: 0x000000)
        
        id = data["id"]! as! String
        
        if cate == ObjectType.Event {
            lblNumberView.text = Utils.convertToString(data["hits"])
            lblNumberFollow.text = Utils.convertToString(data["attend_number"])
        } else {
            lblNumberView.text = Utils.convertToString(data["hit"])
            lblNumberFollow.text = Utils.convertToString(data["follow_number"])
        }
        lblNumberCheckin.text = Utils.convertToString(data["checkin_number"])
        
        if CONVERT_STRING(data["lattitude"]) != "" {
            loadMap(Location(lat: CONVERT_DOUBLE(data["lattitude"]), long: CONVERT_DOUBLE(data["longtitude"])))
        }
        
        let isAttend = CONVERT_BOOL(data["is_attend"])
        let isFollow = CONVERT_BOOL(data["is_follow"])
        if isAttend || isFollow {
            btnLeft.backgroundColor = UIColor.fromRgbHex(0x31ACF9)
            btnLeft.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            activeLeft = true
            btnLeft.setTitle(Localization("Đã quan tâm"), forState: .Normal)
        }
        
        let isCheckin = CONVERT_BOOL(data["is_checkin"])
        if isCheckin {
            btnRight.backgroundColor = UIColor.fromRgbHex(0x31ACF9)
            btnRight.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            activeRight = true
        }
        
        name.text = CONVERT_STRING(data["name"])
        var str = CONVERT_STRING(data["description"])
        str = Utils.HTMLImageCorrector(str)
        str = "<style>input[type=image]{width:\(UIScreen.mainScreen().bounds.size.width-20) !important;height: auto !important;} img{width:\(UIScreen.mainScreen().bounds.size.width-20) !important;height: auto !important;}</style><div style=\"\">" + str + "</div>"
        content.loadHTMLString(str, baseURL: NSURL(string:BASE_URL))
        content.sizeToFit()
        
        location.text = cate == ObjectType.Event ? CONVERT_STRING(data["location"]) : CONVERT_STRING(data["address"])
        if cate == ObjectType.Event && CONVERT_STRING(data["starttime"]) != "" && CONVERT_STRING(data["endtime"]) != "" {
            time.text = Date.sharedInstance.printDateToDate(CONVERT_STRING(data["starttime"]), to: CONVERT_STRING(data["endtime"]))
        } else {
            time.text = Date.sharedInstance.printTimeOpen(CONVERT_STRING(data["starttime"]), to: CONVERT_STRING(data["endtime"]))
        }
        
        listImage = data["photos"] != nil ? data["photos"] as! Array<String> : []
        if listImage.count <= 0 {
            viewPhoto.removeFromSuperview()
        } else {
            album.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
            album.reloadData()
        }
        
        //init tag list view
        tagListView.delegate = self
        if let listTags = data["tags"] as? [Dictionary<String,String>] {
            tagListView.removeAllTags()
            for tag:Dictionary<String,String> in listTags {
                tagListView.addTag(tag["tag"]!, id: tag["tag_id"]!)
            }
            constraintHeightTagList.constant = tagListView.intrinsicContentSize().height
            tagListView.hidden = false
        } else {
            constraintHeightTagList.constant = 0
            tagListView.hidden = true
        }
    }
    
    func loadMap(loc: Location) {
        let camera = GMSCameraPosition.cameraWithLatitude(loc.lat, longitude: loc.long, zoom: 16.0)
        maps.camera = camera
        maps.myLocationEnabled = true
        maps.multipleTouchEnabled = false
        maps.userInteractionEnabled = false
        let img = UIImage(named: "ic_map_maker")
        let lat = loc.lat
        let long = loc.long
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
        marker.icon = img
        marker.map = maps
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickLeft(sender: AnyObject) {
        activeLeft = !activeLeft
        if activeLeft {
            btnLeft.backgroundColor = UIColor.fromRgbHex(0x31ACF9)
            btnLeft.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            btnLeft.setTitle(Localization("Đã quan tâm"), forState: .Normal)
        } else {
            btnLeft.backgroundColor = UIColor.whiteColor()
            btnLeft.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnLeft.setTitle(Localization("Quan Tâm"), forState: .Normal)
        }
        let md = User()
        if cate == ObjectType.Event {
            md.registEvent(id)
        } else {
            md.followHost(id)
        }
    }
    
    @IBAction func clickRight(sender: AnyObject) {
        
    }
}

extension DetailEvent: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellImage", forIndexPath: indexPath) as! CellImage
        let url = listImage[indexPath.row]
        Utils.loadImage(cell.img, link: url)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("SHOW_BROWSER_IMAGE", object: nil, userInfo: ["index": indexPath.row])
    }
}

extension DetailEvent: UIWebViewDelegate {
 
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.New])
        content.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true;
    }
    
    func stopObservingHeight() {
        if observing {
            content.scrollView.removeObserver(self, forKeyPath: "contentSize")
        }
        observing = false
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else {
            super.observeValueForKeyPath(nil, ofObject: object, change: change, context: context)
            return
        }
        switch (keyPath, context) {
        case("contentSize", &MyObservationContext):
            constraintContent.constant = content.scrollView.contentSize.height
        //            stopObservingHeight()
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        constraintContent.constant = content.scrollView.contentSize.height
        NSNotificationCenter.defaultCenter().postNotificationName("RESIZE_HEIGHT_HEADER_DETAIL_EVENT", object: nil, userInfo: ["height": constraintContent.constant])
        if (!observing) {
            startObservingHeight()
        }
    }
}

extension DetailEvent: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        NSNotificationCenter.defaultCenter().postNotificationName("CLICK_TAG_ON_FEED", object: nil, userInfo: ["keyword":(tagView.titleLabel?.text)!])
    }
    
    func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
        
    }
    
}
