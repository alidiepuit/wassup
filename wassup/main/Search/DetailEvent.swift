//
//  DetailEvent.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailEvent: UITableViewCell {
    @IBOutlet weak var content: UITextView!
    
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
    
    var cate = ObjectType.Event
    var id = ""
    var activeLeft = false
    var activeRight = false
    
    var listImage:Array<String> = []
    
    func initData(data:Dictionary<String,AnyObject>) {
        if cate == ObjectType.Event {
            LazyImage.showForImageView(cover, url: CONVERT_STRING(data["image"]))
        } else {
            LazyImage.showForImageView(cover, url: CONVERT_STRING(data["image_profile"]))
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
        }
        
        let isCheckin = data["is_checkin"]! as! Bool
        if isCheckin {
            btnRight.backgroundColor = UIColor.fromRgbHex(0x31ACF9)
            btnRight.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            activeRight = true
        }
        
        name.text = CONVERT_STRING(data["name"])
        do {
            let str = CONVERT_STRING(data["description"])
            let attr = try NSAttributedString(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
                NSFontAttributeName: UIFont(name: "Helvetica", size: 15)!], documentAttributes: nil)
            content.attributedText = attr
            content.sizeToFit()
        } catch {
            
        }
        
        location.text = CONVERT_STRING(data["location"])
        if CONVERT_STRING(data["starttime"]) != "" && CONVERT_STRING(data["endtime"]) != "" {
            time.text = Date.sharedInstance.printDateToDate(CONVERT_STRING(data["starttime"]), to: CONVERT_STRING(data["endtime"]))
        }
        
        listImage = data["photos"] != nil ? data["photos"] as! Array<String> : []
        album.registerNib(UINib(nibName: "CellImage", bundle: nil), forCellWithReuseIdentifier: "CellImage")
        album.reloadData()
    }
    
    func loadMap(loc: Location) {
        let camera = GMSCameraPosition.cameraWithLatitude(loc.lat, longitude: loc.long, zoom: 16.0)
        maps.camera = camera
        maps.myLocationEnabled = true
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
        } else {
            btnLeft.backgroundColor = UIColor.whiteColor()
            btnLeft.setTitleColor(UIColor.blackColor(), forState: .Normal)
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
        LazyImage.showForImageView(cell.img, url: url)
        return cell
    }
}
