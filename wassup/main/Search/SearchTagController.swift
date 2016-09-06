//
//  TabSearchController.swift
//  wassup
//
//  Created by MAC on 8/20/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class SearchTagController: SearchHotController {
    
    var tagId = ""
    var tagName = ""
    
    override func initView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = tagName
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
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
        md.tag(self.tagId, index: page) {
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data:Dictionary<String,AnyObject> = self.data![indexPath.row]
        let objectType = data["object_type"]?.intValue
        if objectType == ObjectType.Event.rawValue || objectType == ObjectType.Host.rawValue {
            return 285
        } else {
            let text = CONVERT_STRING(data["short_description"])
            let hei = text.heightWithConstrainedWidth(self.view.frame.size.width-18, font: UIFont(name: "Helvetica", size: 14)!)
            return 335+hei
        }
    }
}
