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
    var info = InfoMarker()
    
    var tags = [TagView]()
    var listTag = ""
    var centerPoint = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        Utils.sharedInstance.refreshLocation(self, action: #selector(loadMap), loop: false)
        
        geocoder = GMSGeocoder()
        
        let tapBg = UITapGestureRecognizer(target: self, action: #selector(clickBg))
        bg.addGestureRecognizer(tapBg)
        
        info = InfoMarker(frame: CGRect(x: 0, y: bg.frame.size.height-285, width: view.frame.size.width, height: 285))
        
        let tapDetail = UITapGestureRecognizer(target: self, action: #selector(clickDetailEvent))
        info.addGestureRecognizer(tapDetail)
        
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
        
        callAPI(Utils.sharedInstance.location.lat, long: Utils.sharedInstance.location.long)
    }
    
    func callAPI(lat: Double, long: Double) {
        mapView.clear()
        let md = MapsModel()
        md.getEventsOnMap(lat, long: long, keyword: "", tags: listTag) {
            (result:AnyObject?) in
            let dict = result!["events"] as! [Dictionary<String, String>]
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
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickBg() {
        info.removeFromSuperview()
        bg.hidden = true
    }
    
    @IBAction func clickSearchTag(sender: AnyObject) {
        performSegueWithIdentifier("SearchTag", sender: nil)
    }
}

extension MapsController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        let handler = { (response: GMSReverseGeocodeResponse?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                self.centerPoint = cameraPosition.target
            }
        }
        geocoder.reverseGeocodeCoordinate(cameraPosition.target, completionHandler: handler)
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        
        if let marker = marker as? MyMarker {
            selectedItem = marker
            info.initData(marker.data)
            
            self.bg.hidden = false
            self.view.addSubview(info)
        }
        return nil
    }
    
    func clickDetailEvent() {
        performSegueWithIdentifier("DetailEvent", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailEvent" {
            let vc = segue.destinationViewController as! DetailEventController
            vc.data = selectedItem.data
        }
        
        if segue.identifier == "SearchTag" {
            let vc = segue.destinationViewController as! MapSearchTagController
            vc.listSelected = tags
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        markerCenter.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        markerCenter.fadeIn(0.25)
        return false
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            markerCenter.fadeIn(0.25)
        }
    }
}
