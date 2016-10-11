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
    var saveData:Dictionary<String,AnyObject>!
    var indexPath:NSIndexPath!
    
    override var cate:ObjectType {
        return ObjectType.Article
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(bookmarkFromMainView(_:)), name: "BOOKMARK_FROM_MAIN_VIEW", object: nil)
    }
    
    override func refreshDataFilter(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        action = "\(CONVERT_STRING(d["time"]))"
        districtId = CONVERT_STRING(d["district"])
        resetData()
        loadData()
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
        
    }
    
    override func loadData() {
        if isFinish {
            return
        }
        isLoading = true
        let md = Search()
        md.blogs(0, index: page, keyword: "", action: action, districtId: districtId) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CellBlog", forIndexPath: indexPath) as! CellBlog
        
        let data:Dictionary<String,AnyObject> = self.data![indexPath.row]
        cell.initCell(data)
        cell.indexPath = indexPath
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DetailBlog", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailBlog" {
            let next = segue.destinationViewController as! DetailBlogController
            if let data:Dictionary<String,AnyObject> = self.data![(tableView.indexPathForSelectedRow?.row)!] {
                next.id = CONVERT_STRING(data["id"])
            }
        }
        
        if (segue.identifier == "SaveCollection") {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! ListCollectionController
            vc.objectId = CONVERT_STRING(self.saveData["id"])
            vc.objectType = CollectionType.Article
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let data:Dictionary<String,AnyObject> = self.data![indexPath.row] {
            let text = CONVERT_STRING(data["short_description"])
            let hei = text.heightWithConstrainedWidth(self.view.frame.size.width-18, font: UIFont(name: "Helvetica", size: 14)!)
            return 335+hei
        }
    }
    
    
    
    func bookmarkFromMainView(noti: NSNotification) {
        let userInfo = noti.userInfo as! Dictionary<String,AnyObject>
        self.saveData = userInfo["data"] as! Dictionary<String,AnyObject>
        self.indexPath = userInfo["indexPath"] as! NSIndexPath
        self.performSegueWithIdentifier("SaveCollection", sender: nil)
    }
    
    @IBAction func saveBookmark(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ListCollectionController, item = sourceViewController.selectedItemCollection {
            let objectId = CONVERT_STRING(self.saveData["id"])
            let objectType = CollectionType.Article
            let md = Collection()
            md.bookmark(CONVERT_STRING(item["id"]), collectionName: CONVERT_STRING(item["name"]), objectId: objectId, objectType: objectType.rawValue) {
                (result:AnyObject?) in
                if let res = result as? Dictionary<String,AnyObject> {
                    let status = CONVERT_INT(res["status"])
                    if status == 1 {
                        var d = self.data[self.indexPath.row]
                        d["is_bookmark"] = 1
                        self.data[self.indexPath.row] = d
                        self.tableView.reloadRowsAtIndexPaths([self.indexPath], withRowAnimation: .Automatic)
                    }
                }
            }
        }
    }
}
