//
//  SearchBlogController.swift
//  wassup
//
//  Created by MAC on 8/24/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class SearchBlogController: SearchEventController {
    var filterBlog:FilterBlog?
    
    override var cate:ObjectType {
        return ObjectType.Article
    }
    
    override func refreshDataFilter(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        action = "\(CONVERT_STRING(d["time"]))"
        districtId = CONVERT_STRING(d["district"])
        self.data = nil
        self.page = 1
        loadData(nil)
    }
    
    override func initFilter() {
        self.filterBlog = FilterBlog(frame: insideView!.frame)
        self.filterBlog?.hidden = true
        action = "1"
    }
    
    override func clickFilter() {
        if self.filterBlog!.hidden {
            self.parentViewController?.view.addSubview(self.filterBlog!)
            filterBlog?.hidden = false
            filterBlog?.resetData()
        } else {
            self.filterBlog!.removeFromSuperview()
            filterBlog?.hidden = true
        }
    }
    
    override func selectProvince(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        self.filterBlog?.cityId = CellDropdown(id: d["cityId"]!, value: d["cityName"]!)
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
        md.blogs(0, index: page, keyword: "", action: action, districtId: districtId) {
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellBlog", forIndexPath: indexPath) as! CellBlog
        
        let data:Dictionary<String,AnyObject> = self.data![indexPath.row]
        cell.initCell(data)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DetailBlog", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let next = segue.destinationViewController as! DetailBlogController
        if let data:Dictionary<String,AnyObject> = self.data![(tableView.indexPathForSelectedRow?.row)!] {
            next.id = CONVERT_STRING(data["id"])
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let data:Dictionary<String,AnyObject> = self.data![indexPath.row] {
            let text = CONVERT_STRING(data["short_description"])
            let hei = text.heightWithConstrainedWidth(self.view.frame.size.width-18, font: UIFont(name: "Helvetica", size: 14)!)
            return 335+hei
        }
    }
}
