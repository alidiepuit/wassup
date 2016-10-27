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
    @IBOutlet weak var markerCenter: UIImageView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var infoMarker: InfoMarker!
    
    @IBOutlet weak var topView: UIView!
    var cellSearch:CellSearch!
    var selectedItem:MyMarker!
    var geocoder:GMSGeocoder!
    var debounceTimer: NSTimer?
    var listTag = ""
    var centerPoint = CLLocationCoordinate2D()
    var oldCenterPoint = CLLocationCoordinate2D()

    var isMoving = false
    var isLoading = false
    let heightInfo = CGFloat(285)
    let animationDuration = 0.5
    var tabPage:TabPageViewController!
    var listSelectedTags = [TagView]()
    var cate = ObjectType.Host
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("MapsEventHostController") as! MapsEventHostController
        vc1.cate = ObjectType.Event
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("MapsEventHostController") as! MapsEventHostController
        vc2.cate = ObjectType.Host
        tabPage!.tabItems = [(vc2, Localization("Địa điểm")), (vc1, Localization("Sự kiện"))]
        tabPage!.pageViewDelegate = self
        
        var option = TabPageOption()
        option.currentColor = UIColor.fromRgbHex(0x31ACF9)
        option.tabEqualizeWidth = true
        option.numberOfItem = 2
        option.tabHeight = 44
        tabPage!.option = option
        
        self.addChildViewController(tabPage!)
        tabPage!.view.frame = self.topView.frame
        self.topView.addSubview(tabPage!.view)
        
        Utils.sharedInstance.refreshLocation(self, action: #selector(loadMap), loop: false)
        
        geocoder = GMSGeocoder()
        
        let tapBg = UITapGestureRecognizer(target: self, action: #selector(clickBg))
        bg.addGestureRecognizer(tapBg)
        
        //        info = InfoMarker(frame: CGRect(x: 0, y: self.view.frame.size.height-heightInfo, width: self.view.frame.size.width, height: heightInfo))
        
        let tapDetail = UITapGestureRecognizer(target: self, action: #selector(clickDetailEvent))
        //        info.addGestureRecognizer(tapDetail)
        infoMarker.addGestureRecognizer(tapDetail)
        
    }
    
    func selectObjectType() {
        if centerPoint.latitude != 0.0 && centerPoint.longitude != 0.0 {
            callAPI(centerPoint.latitude, long: centerPoint.longitude)
        } else {
            Utils.sharedInstance.refreshLocation(self, action: #selector(loadMap), loop: false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if !CLLocationManager.locationServicesEnabled() {
            let alert = UIAlertView(title: Localization("Thông báo"), message: Localization("Bạn chưa bật GPS"), delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        if CLLocationManager.authorizationStatus() == .Denied {
            let alert = UIAlertView(title: Localization("Thông báo"), message: Localization("Bạn chưa cho phép ứng dụng sử dụng GPS"), delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSearchTag(sender: AnyObject) {
        performSegueWithIdentifier("SearchTag", sender: nil)
    }
    
    @IBAction func saveSearchTag(segue: UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? MapSearchTagController {
            listSelectedTags = vc.listSelected
            listTag = ""
            for a in listSelectedTags {
                if listTag != "" {
                    listTag += ","
                }
                listTag += a.id
            }
            selectObjectType()
        }
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
        self.view.lock()
        let md = MapsModel()
        if cate == ObjectType.Event {
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
        self.view.unlock()
    }
    
    func searchMapWhenStop() {
        isMoving = false
        callAPI(self.centerPoint.latitude, long: self.centerPoint.longitude)
    }
    
    func clickBg() {
        UIView.animateWithDuration(self.animationDuration, delay: 0.0, options: [], animations: {
            let top = CGAffineTransformMakeTranslation(0, self.heightInfo)
            self.infoMarker.transform = top
            }, completion: nil)
        bg.hidden = true
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
            infoMarker.cate = self.cate
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
            vc.cate = cate
            vc.data = selectedItem.data
        }
        
        if segue.identifier == "SearchTag" {
            let vc = segue.destinationViewController as! MapSearchTagController
            vc.listSelected = listSelectedTags
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
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

extension MapsController: TabPageViewDelegate {
    func didTabPage(vc: UIViewController) {
        let v = vc as! MapsEventHostController
        cate = v.cate
        selectObjectType()
    }
    
    func didFinishScroll() {
        
    }
}
