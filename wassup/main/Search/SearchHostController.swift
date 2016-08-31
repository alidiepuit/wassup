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
        action = "\(CONVERT_STRING(d["time"]))"
        districtId = CONVERT_STRING(d["district"])
        self.data = nil
        self.page = 1
        loadData(nil)
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
    }
    
    override func loadData(ref: UIRefreshControl?) {
        if isFinish {
            return
        }
        isLoading = true
        if ref != nil {
            self.data = nil
            page = 1
        }
        let md = Search()
        md.hosts(1, index: page, keyword: "", action: action, districtId: districtId) {
            (result:AnyObject?) in
            if result != nil {
                guard let d = result!["objects"] as? [Dictionary<String, AnyObject>] else {
                    self.data = nil
                    return
                }
                if self.data == nil {
                    self.data = d
                } else {
                    if d.count <= 0 {
                        self.isFinish = true
                    }
                    self.data?.appendContentsOf(d)
                }
                self.tableView.reloadData()
            }
            if ref != nil {
                ref!.endRefreshing()
            }
            self.isLoading = false
        }
    }
}
