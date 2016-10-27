//
//  SearchHostController.swift
//  wassup
//
//  Created by MAC on 8/24/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class SearchHostController: SearchEventController {
    
    override var cate:ObjectType {
        return ObjectType.Host
    }
    
    var filterHost:FilterHost?
    
    override func refreshDataFilter(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        action = "\(CONVERT_STRING(d["time"])),9"
        districtId = CONVERT_STRING(d["district"])
        city = CONVERT_STRING(d["city"])
        
        if d["district"] == "" {
            action = "\(CONVERT_STRING(d["time"])),12"
        }
        
        resetData()
        loadData()
    }
    
    override func initFilter() {
        self.filterHost = FilterHost(frame: insideView!.frame)
        self.filterHost?.hidden = true
    }
    
    override func clickFilter() {
        if self.filterHost!.hidden {
            self.parentViewController?.view.addSubview(self.filterHost!)
            filterHost?.hidden = false
            filterHost?.resetData()
        } else {
            self.filterHost!.removeFromSuperview()
            filterHost?.hidden = true
        }
    }
    
    override func selectProvince(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        self.filterHost?.cityId = CellDropdown(id: d["cityId"]!, value: d["cityName"]!)
        action = "1,12"
        city = d["cityName"]!
        resetData()
        loadData()
    }
    
    override func loadData() {
        if isFinish {
            return
        }
        isLoading = true
        let md = Search()
        md.hosts(0, index: page, keyword: "", action: action, districtId: districtId, city: city) {
            (result:AnyObject?) in
            if result != nil {
                guard let d = result!["objects"] as? [Dictionary<String, AnyObject>] else {
                    return
                }
                if d.count <= 0 {
                    self.isFinish = true
                }
                for a:Dictionary<String,AnyObject> in d {
                    self.data!.append(a)
                    let lastIndexPath = NSIndexPath(forRow: self.data!.count - 1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([lastIndexPath], withRowAnimation: .None)
                }
            }
            self.ref.endRefreshing()
            self.isLoading = false
        }
    }
}
