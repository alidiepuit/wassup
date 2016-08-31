//
//  SubSearchKeyword.swift
//  wassup
//
//  Created by MAC on 8/30/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class SubSearchKeyword: UITableViewController {

    var keyword = ""
    var page = 1
    var typeSearch = ObjectType.Tag
    var data = [Dictionary<String,AnyObject>]()
    var isLoading = false
    let ref = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inset = UIEdgeInsetsMake(TabPageOption().tabHeight, 0, 0, 0)
        tableView.contentInset = inset;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData(_:)), name: "LOAD_DATA_SEARCH", object: nil)
        
        
        ref.addTarget(self, action: #selector(loadMoreData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
    }
    
    func loadData(noti: NSNotification?) {
        if noti != nil {
            let d = noti!.userInfo as! Dictionary<String,String>
            keyword = d["keyword"]!
        }
        let md = Search()
        if page <= 1 {
            self.data.removeAll()
        }
        md.keyword(keyword, index: page) {
            (result:AnyObject?) in
            if result != nil {
                if let d = result!["objects"] as? [Dictionary<String,AnyObject>] {
                    for ele:Dictionary<String,AnyObject> in d {
                        let objectType = ele["object_type"]?.intValue
                        if objectType == self.typeSearch.rawValue {
                            self.data.append(ele)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            self.ref.endRefreshing()
        }
    }
    
    func loadMoreData(ref: UIRefreshControl?) {
        page = 1
        loadData(nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let d = self.data[indexPath.row] 
        switch self.typeSearch {
        case .Tag:
            let cell = tableView.dequeueReusableCellWithIdentifier("CellTag", forIndexPath: indexPath) as! CellTag
            cell.name.text = CONVERT_STRING(d["name"])
            cell.info.text = "\(CONVERT_STRING(d["total_event"])) \(Localization("Sự kiện")) | \(CONVERT_STRING(d["total_host"])) \(Localization("Địa điểm")) | \(CONVERT_STRING(d["total_article"])) \(Localization("Bài viết"))"
            return cell
        case .Users:
            let cell = tableView.dequeueReusableCellWithIdentifier("CellUser", forIndexPath: indexPath) as! CellFollower
            LazyImage.showForImageView(cell.avatar, url: CONVERT_STRING(d["image"]))
            cell.name.text = CONVERT_STRING(d["name"])
            cell.address.text = CONVERT_STRING(d["location"])
            if CONVERT_BOOL(d["is_follow"]) {
                cell.btnFollow.hidden = true
                cell.btnFollowed.hidden = false
            }
            if User.sharedInstance.userId == CONVERT_STRING(d["id"]) {
                cell.btnFollow.hidden = true
                cell.btnFollowed.hidden = true
            }
            cell.userId = CONVERT_STRING(d["id"])
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("CellEvent", forIndexPath: indexPath) as! CellEvent
            LazyImage.showForImageView(cell.avatar, url: CONVERT_STRING(d["image"]))
            cell.name.text = CONVERT_STRING(d["name"])
            
            cell.address.text = ""
            if self.typeSearch != ObjectType.Article {
                cell.address.text = CONVERT_STRING(d["location"])
            }
            
            cell.time.text = ""
            if self.typeSearch == ObjectType.Event {
                cell.time.text = Date().printDateToDate(CONVERT_STRING(d["starttime"]), to: CONVERT_STRING(d["endtime"]))
            }
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isLoading && indexPath.row == data.count-1 {
            page += 1
            loadData(nil)
        }
    }
}
