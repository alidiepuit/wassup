//
//  TabSearchController.swift
//  wassup
//
//  Created by MAC on 8/20/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class SearchHotController: SearchEventController {
    
    override func clickFilter() {
        return
    }
    
    override func initFilter() {
        return
    }
    
    override func loadData() {
        if isFinish {
            return
        }
        isLoading = true
        let md = Search()
        md.hot(0, index: page, keyword: "", action: action, districtId: districtId) {
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data:Dictionary<String,AnyObject> = self.data![indexPath.row]
        let objectType = CONVERT_INT(data["object_type"])
        if objectType == ObjectType.Article.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellBlog", forIndexPath: indexPath) as! CellBlog
            cell.initCell(data)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellSearch", forIndexPath: indexPath) as! CellSearch
        if objectType == ObjectType.Event.rawValue {
            cell.cate = ObjectType.Event
        } else {
            cell.cate = ObjectType.Host
        }
        cell.id = CONVERT_STRING(data["id"])
        cell.initCell(data)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data:Dictionary<String,AnyObject> = self.data![indexPath.row]
        let objectType = CONVERT_INT(data["object_type"])
        if objectType == ObjectType.Event.rawValue || objectType == ObjectType.Host.rawValue{
            self.performSegueWithIdentifier("DetailEvent", sender: nil)
        } else {
            self.performSegueWithIdentifier("DetailBlog", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailEvent" || segue.identifier == "DetailHost" || segue.identifier == "DetailBlog" {
            if let data:Dictionary<String,AnyObject> = self.data![(tableView.indexPathForSelectedRow?.row)!] {
                if segue.identifier == "DetailEvent" {
                    let next = segue.destinationViewController as! DetailEventController
                    next.data = data
                    let objectType = CONVERT_INT(data["object_type"])
                    if objectType == ObjectType.Event.rawValue {
                        next.cate = ObjectType.Event
                    } else {
                        next.cate = ObjectType.Host
                    }
                } else {
                    let next = segue.destinationViewController as! DetailBlogController
                    next.id = CONVERT_STRING(data["id"])
                }
            }
        }
    }
}
