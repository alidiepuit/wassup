//
//  DetailEventController.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class AboutDetailEventController: UITableViewController {

    var data:Dictionary<String,AnyObject>?
    var page = 1
    var listFeeds:[Dictionary<String,AnyObject>]?
    var finishDetail = false
    var finishFeeds = true
    var isLoadingMore = false
    var cate = ObjectType.Event
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DetailEvent", bundle: nil), forCellReuseIdentifier: "DetailEvent")
        tableView.registerNib(UINib(nibName: "CellFeed", bundle: nil), forCellReuseIdentifier: "CellFeed")
        
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(loadData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        loadData(nil)
//        loadFeed()
    }
    
    func loadData(ref: UIRefreshControl?) {
        finishDetail = false
        let md = Search()
        if cate == ObjectType.Event {
            md.eventDetailEvent(self.id) {
                (result:AnyObject?) in
                self.finishDetail = true
                if result != nil {
                    guard let d = result!["event"] as? Dictionary<String, AnyObject> else {
                        self.data = nil
                        return
                    }
                    self.data = d
                    if self.finishDetail && self.finishFeeds {
                        self.tableView.reloadData()
                    }
                }
                if ref != nil {
                    ref!.endRefreshing()
                }
            }
        } else {
            md.eventDetailHost(self.id) {
                (result:AnyObject?) in
                self.finishDetail = true
                if result != nil {
                    guard let d = result!["host"] as? Dictionary<String, AnyObject> else {
                        self.data = nil
                        return
                    }
                    self.data = d
                    if self.finishDetail {
                        self.tableView.reloadData()
                    }
                }
                if ref != nil {
                    ref!.endRefreshing()
                }
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
        if section == 0 {
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
            do {
                let label:UILabel = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, CGFloat.max))
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                label.font = UIFont(name: "Helvetica", size: 15.0)
                let str = CONVERT_STRING(self.data!["description"])
                let attr = try NSAttributedString(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding,
                    NSFontAttributeName: UIFont(name: "Helvetica", size: 15)!], documentAttributes: nil)
                label.attributedText = attr
                label.sizeToFit()
                return 800+label.frame.size.height+50
            } catch {
                
            }
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
