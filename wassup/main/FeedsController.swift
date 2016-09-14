//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class FeedsController: UITableViewController {
    
    var page = 1
    var data = [Dictionary<String, AnyObject>]()
    let ref = UIRefreshControl()
    var loading = false
    var isFinished = false
    var indexPath = NSIndexPath(index: 0)
    var sectionHasData:Int {
        return 0
    }
    var detailProfile:Dictionary<String,AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        callAPI()
        
        initTable()
    }
    
    func initTable() {
        tableView.registerNib(UINib(nibName: "CellFeed", bundle: nil), forCellReuseIdentifier: "CellFeed")
        
        ref.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clickTagOnFeed), name: "CLICK_TAG_ON_FEED", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clickStatusGoToDetailEventOnFeed), name: "CLICK_STATUS_GO_TO_DETAIL_EVENT_ON_FEED", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clickStatusGoToProfileOnFeed), name: "CLICK_STATUS_GO_TO_PROFILE_ON_FEED", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clickBookmarkOnFeed(_:)), name: "CLICK_BOOKMARK_ON_FEED", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func clickTagOnFeed(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String,String>
        GLOBAL_KEYWORD = d["keyword"]!
        performSegueWithIdentifier("SearchKeyword", sender: nil)
    }
    
    func clickStatusGoToDetailEventOnFeed(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String,AnyObject>
        self.tableView(tableView, didSelectRowAtIndexPath: d["indexPath"] as! NSIndexPath)
    }
    
    func clickBookmarkOnFeed(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String,AnyObject>
        indexPath = d["indexPath"] as! NSIndexPath
        performSegueWithIdentifier("SaveCollection", sender: nil)
    }
    
    func clickStatusGoToProfileOnFeed(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String,String>
        let md = User()
        md.getUserProfile(d["userId"]!) {
            (result:AnyObject?) in
            self.detailProfile = result!["user"] as! Dictionary<String,AnyObject>
            self.performSegueWithIdentifier("DetailProfile", sender: nil)
        }
    }
    
    func refreshData(ref: UIRefreshControl) {
        page = 1
        self.data.removeAll()
        tableView.reloadData()
        callAPI()
    }
    
    func callAPI() {
        let md = Feeds()
        loading = true
        md.getFeeds(index: page) {
            (result: AnyObject?) in
            if result != nil {
                if let d = result!["activities"] as? [Dictionary<String,AnyObject>] {
                    if d.count <= 0 {
                        self.isFinished = true
                    }
                    for a in d {
                        let item = a["item"] as! Dictionary<String,AnyObject>
                        let objectId = item["id"]
                        if CONVERT_STRING(objectId) != "" {
                            self.data.append(a)
                            let lastIndexPath = NSIndexPath(forRow: self.data.count - 1, inSection: 0)
                            self.tableView.insertRowsAtIndexPaths([lastIndexPath], withRowAnimation: .None)
                        }
                    }
                }
                self.loading = false
                self.ref.endRefreshing()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if sectionHasData == indexPath.section {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellFeed", forIndexPath: indexPath) as! CellFeed
            
            let d:Dictionary<String,AnyObject> = data[indexPath.row]
            cell.initCell(d)
            cell.indexPath = indexPath
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("CellFeed", forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let d:Dictionary<String,AnyObject> = data[indexPath.row]
        let item = d["item"] as! Dictionary<String,AnyObject>
        let comment = CONVERT_STRING(item["comment"])
        let heiComment = comment.heightWithConstrainedWidth(tableView.frame.size.width-30, font: UIFont(name: "Helvetica", size: 14)!)
        let heiLocation = CONVERT_STRING(item["location"]) != "" ? 77 : 0
        
        var heiListTag = CGFloat(0)
        if let feelings = item["feelings"] as? Dictionary<String,AnyObject> {
            if let _ = feelings["3"] as? [Dictionary<String,String>] {
                let listTags = feelings["3"] as! [Dictionary<String,String>]
                let viewlistTags = TagListView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 30, height: 53))
                viewlistTags.paddingY = 10
                viewlistTags.paddingX = 15
                viewlistTags.marginY = 10
                viewlistTags.marginX = 10
                viewlistTags.removeAllTags()
                viewlistTags.cornerRadius = 15
                viewlistTags.borderWidth = 2
                for tag:Dictionary<String,String> in listTags {
                    viewlistTags.addTag(tag["text_feeling"]!, id: tag["id"]!)
                }
                heiListTag = viewlistTags.intrinsicContentSize().height
            }
        }
        
        return heiComment + CGFloat(heiLocation) + CGFloat(heiListTag) + 320;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !loading && !isFinished && indexPath.row == data.count-1 {
            page += 1
            callAPI()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.indexPath = indexPath
        self.performSegueWithIdentifier("DetailEvent", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SearchKeyword" {
            let dest = segue.destinationViewController as! SearchKeyword
            dest.searchBar.text = GLOBAL_KEYWORD
        }
        if segue.identifier == "DetailEvent" {
            let vc = segue.destinationViewController as! DetailEventController
            let d:Dictionary<String,AnyObject> = self.data[self.indexPath.row]
            let item:Dictionary<String,AnyObject> = d["item"] as! Dictionary<String,AnyObject>
            var data = Dictionary<String,String>()
            data["name"] = CONVERT_STRING(item["title"])
            if CONVERT_STRING(item["event_id"]) != "" {
                vc.cate = ObjectType.Event
                data["id"] = CONVERT_STRING(item["event_id"])
            } else if CONVERT_STRING(item["host_id"]) != "" {
                vc.cate = ObjectType.Host
                data["id"] = CONVERT_STRING(item["host_id"])
            }
            vc.data = data
        }
        
        if segue.identifier == "DetailProfile" {
            let navi = segue.destinationViewController as! UINavigationController
            let vc = navi.topViewController as! ProfileController
            vc.data = detailProfile
        }
        
        if segue.identifier == "SaveCollection" {
            let vc = segue.destinationViewController as! ListCollectionController
            let d:Dictionary<String,AnyObject> = self.data[indexPath.row]
            vc.objectId = CONVERT_STRING(d["object_id"])
            vc.objectType = CollectionType.Feed
        }
    }
}
