//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsController: UIViewController {
    
    @IBOutlet weak var mapView:GMSMapView!
    var geocoder:GMSGeocoder!
    @IBOutlet weak var markerCenter: UIImageView!
    var cellSearch:CellSearch!
    @IBOutlet weak var bg: UIView!
    var selectedItem:MyMarker!
    @IBOutlet weak var infoMarker: InfoMarker!
    
    var debounceTimer: NSTimer?
    var tags = [TagView]()
    var listTag = ""
    var centerPoint = CLLocationCoordinate2D()
    var oldCenterPoint = CLLocationCoordinate2D()
    var paramResult = "events"
    var isMoving = false
    let heightInfo = CGFloat(285)
    let animationDuration = 0.5
    
    @IBOutlet weak var selectType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        Utils.sharedInstance.refreshLocation(self, action: #selector(loadMap), loop: false)
        
        geocoder = GMSGeocoder()
        
        let tapBg = UITapGestureRecognizer(target: self, action: #selector(clickBg))
        bg.addGestureRecognizer(tapBg)
        
//        info = InfoMarker(frame: CGRect(x: 0, y: self.view.frame.size.height-heightInfo, width: self.view.frame.size.width, height: heightInfo))
        
        let tapDetail = UITapGestureRecognizer(target: self, action: #selector(clickDetailEvent))
//        info.addGestureRecognizer(tapDetail)
        infoMarker.addGestureRecognizer(tapDetail)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(searchMapWithTag(_:)), name: "SEARCH_MAP_WITH_TAG", object: nil)
    }
    
    func searchMapWithTag(noti: NSNotification) {
        let data = noti.userInfo as! Dictionary<String,AnyObject>
        tags = data["tags"] as! [TagView]
        listTag = ""
        for a in tags {
            if listTag != "" {
                listTag += ","
            }
            listTag += a.id
        }
        callAPI(centerPoint.latitude, long: centerPoint.longitude)
    }
    
    func loadMap() {
        let camera = GMSCameraPosition.cameraWithLatitude(Utils.sharedInstance.location.lat, longitude: Utils.sharedInstance.location.long, zoom: 16.0)
        mapView.camera = camera
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        self.centerPoint = CLLocationCoordinate2D(latitude: Utils.sharedInstance.location.lat, longitude: Utils.sharedInstance.location.long)
    }
    
    func callAPI(lat: Double, long: Double) {
        if isMoving {
            return
        }
        let md = MapsModel()
        if selectType.selectedSegmentIndex == 0 {
            md.getEventsOnMap(lat, long: long, keyword: "", tags: listTag) {
                result in
                self.handleData(result!["events"] as! [Dictionary<String, String>])
            }
        } else {
            md.getHostsOnMap(lat, long: long, keyword: "", tags: listTag) {
                result in
                self.handleData(result!["hosts"] as! [Dictionary<String, String>])
            }
        }
    }
    
    func handleData(dict:[Dictionary<String, String>]) {
        mapView.clear()
        let img = UIImage(named: "ic_map_maker")
        for a:Dictionary<String, String> in dict {
            let lat = CONVERT_DOUBLE(a["lattitude"]!)
            let long = CONVERT_DOUBLE(a["longtitude"]!)
            let marker = MyMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
            marker.icon = img
            marker.map = self.mapView
            marker.data = a
        }
    }
    
    func searchMapWhenStop() {
        isMoving = false
        callAPI(self.centerPoint.latitude, long: self.centerPoint.longitude)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickBg() {
        UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: [], animations: {
            let top = CGAffineTransformMakeTranslation(0, self.heightInfo)
            self.infoMarker.transform = top
            }, completion: nil)
        bg.hidden = true
    }
    
    @IBAction func clickSearchTag(sender: AnyObject) {
        performSegueWithIdentifier("SearchTag", sender: nil)
    }
    
    @IBAction func clickSelectType(sender: AnyObject) {
        paramResult = selectType.selectedSegmentIndex == 0 ? "events" : "hosts"
        callAPI(centerPoint.latitude, long: centerPoint.longitude)
        clickBg()
    }
    
}

extension MapsController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        let handler = { (response: GMSReverseGeocodeResponse?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
//            if let result = response?.firstResult() {
//                self.centerPoint = cameraPosition.target
//            }
            self.centerPoint = cameraPosition.target
            if let timer = self.debounceTimer {
                timer.invalidate()
            }
            self.debounceTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(self.searchMapWhenStop), userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(self.debounceTimer!, forMode: "NSDefaultRunLoopMode")
        }
        isMoving = true
        if let timer = self.debounceTimer {
            timer.invalidate()
        }
        geocoder.reverseGeocodeCoordinate(cameraPosition.target, completionHandler: handler)
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let marker = marker as? MyMarker {
            selectedItem = marker
            infoMarker.cate = selectType.selectedSegmentIndex == 0 ? ObjectType.Event : ObjectType.Host
            infoMarker.initData(marker.data)
            
            self.bg.hidden = false
            
            UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: [], animations: {
                    let top = CGAffineTransformMakeTranslation(0, -self.heightInfo)
                    self.infoMarker.transform = top
                }, completion: nil)
        }
        return nil
    }
    
    func clickDetailEvent() {
        performSegueWithIdentifier("DetailEvent", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailEvent" {
            let vc = segue.destinationViewController as! DetailEventController
            vc.cate = selectType.selectedSegmentIndex == 0 ? ObjectType.Event : ObjectType.Host
            vc.data = selectedItem.data
        }
        
        if segue.identifier == "SearchTag" {
            let vc = segue.destinationViewController as! MapSearchTagController
            vc.listSelected = tags
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
//        markerCenter.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
//        markerCenter.fadeIn(0.25)
        return false
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
//            markerCenter.fadeIn(0.25)
        }
    }
}
