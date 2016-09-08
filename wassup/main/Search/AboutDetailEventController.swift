//
//  DetailEventController.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class AboutDetailEventController: UITableViewController {

    var data:Dictionary<String,AnyObject>!
    var page = 1
    var listFeeds:[Dictionary<String,AnyObject>]?
    var finishDetail = false
    var finishFeeds = true
    var isLoadingMore = false
    var cate = ObjectType.Event
    var id = ""
    let ref = UIRefreshControl()
    
    var headerHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset = UIEdgeInsetsMake(45, 0, 0, 0)
        tableView.contentInset = inset;
        
        tableView.registerNib(UINib(nibName: "DetailEvent", bundle: nil), forCellReuseIdentifier: "DetailEvent")
        tableView.registerNib(UINib(nibName: "CellFeed", bundle: nil), forCellReuseIdentifier: "CellFeed")
        
        ref.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        loadData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(resizeHeightHeader(_:)), name: "RESIZE_HEIGHT_HEADER_DETAIL_EVENT", object: nil)
    }
    
    func resizeHeightHeader(noti: NSNotification) {
        if headerHeight == 0 {
            let d = noti.userInfo as! Dictionary<String,CGFloat>
            headerHeight = d["height"]!
            tableView.reloadData()
        }
    }
    
    func refreshData(ref: UIRefreshControl) {
        loadData()
    }
    
    func loadData() {
        finishDetail = false
        let md = Search()
        if cate == ObjectType.Event {
            md.eventDetailEvent(self.id) {
                (result:AnyObject?) in
                self.finishDetail = true
                if result != nil {
                    guard let d = result!["event"] as? Dictionary<String, AnyObject> else {
                        return
                    }
                    self.data = d
                    if self.finishDetail && self.finishFeeds {
                        self.tableView.reloadData()
                    }
                }
                self.ref.endRefreshing()
            }
        } else {
            md.eventDetailHost(self.id) {
                (result:AnyObject?) in
                self.finishDetail = true
                if result != nil {
                    guard let d = result!["host"] as? Dictionary<String, AnyObject> else {
                        return
                    }
                    self.data = d
                    if self.finishDetail {
                        self.tableView.reloadData()
                    }
                }
                self.ref.endRefreshing()
            }
        }
    }
    
    func loadFeed() {
        finishFeeds = false
        let md = Feeds()
        md.listEventFeeds(CONVERT_STRING(data!["id"]), index: page, top: 0){
            (result:AnyObject?) in
            self.finishFeeds = true
            self.isLoadingMore = false
            if result != nil {
                guard let d = result as? [Dictionary<String, AnyObject>] else {
                    self.listFeeds = []
                    return
                }
                self.listFeeds = d
                if self.finishDetail && self.finishFeeds {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return listFeeds != nil ? (listFeeds?.count)! : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellFeed", forIndexPath: indexPath) as! CellFeed
        let d = listFeeds![indexPath.row]
        cell.initCell(d)
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && self.data != nil {
            let  headerCell = tableView.dequeueReusableCellWithIdentifier("DetailEvent") as! DetailEvent
            headerCell.cate = cate
            headerCell.initData(self.data!)
            return headerCell
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 && self.data != nil {
            if headerHeight == 0 {
                do {
                    let str = CONVERT_STRING(self.data!["description"])
                    let attr = try NSAttributedString(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
                        NSFontAttributeName: UIFont(name: "Helvetica", size: 15)!], documentAttributes: nil)
                    let hei = attr.heightWithConstrainedWidth(tableView.frame.size.width-16)
                    return 800+hei
                } catch {
                    return 800
                }
            }
            return 800+headerHeight
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isLoadingMore && indexPath.row == (listFeeds?.count)!-1 {
            isLoadingMore = true
            page += 1
            loadFeed()
        }
    }
}
