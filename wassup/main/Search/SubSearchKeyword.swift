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
    var isFirstLoad = true
    var finishData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inset = UIEdgeInsetsMake(TabPageOption().tabHeight, 0, 0, 0)
        tableView.contentInset = inset;
      
        ref.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        tableView.registerNib(UINib(nibName: "CellFollower", bundle: nil), forCellReuseIdentifier: "CellFollower")
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData(_:)), name: "RELOAD_DATA_SEARCH_WHEN_APPEAR", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData(_:)), name: "LOAD_DATA_SEARCH_WITH_NEW_KEYWORD", object: nil)
//        refreshData(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadData(_:)), name: "LOAD_DATA_SEARCH_WITH_NEW_KEYWORD", object: nil)
        refreshData(nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "LOAD_DATA_SEARCH_WITH_NEW_KEYWORD", object: nil)
    }
    
    func loadData(noti: NSNotification?) {
        if !isFirstLoad && GLOBAL_KEYWORD == self.keyword {
            return
        }
        isFirstLoad = false
        refreshData(nil)
    }
    
    func refreshData(ref: UIRefreshControl?) {
        page = 1
        self.data.removeAll()
        self.keyword = GLOBAL_KEYWORD
        loadData()
    }
    
    func loadData() {
        let md = Search()
        md.keyword(keyword, index: page) {
            (result:AnyObject?) in
            if result != nil {
                if let d = result!["objects"] as? [Dictionary<String,AnyObject>] {
                    if d.count <= 0 {
                        self.finishData = true
                    }
                    for ele:Dictionary<String,AnyObject> in d {
                        let objectType = ele["object_type"]?.intValue
                        if objectType == self.typeSearch.rawValue {
                            self.data.append(ele)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            self.isLoading = false
            self.ref.endRefreshing()
        }
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
        if let d:Dictionary<String,AnyObject> = self.data[indexPath.row] {
            switch self.typeSearch {
            case .Tag:
                let cell = tableView.dequeueReusableCellWithIdentifier("CellTag", forIndexPath: indexPath) as! CellTag
                cell.name.text = CONVERT_STRING(d["name"])
                cell.info.text = "\(CONVERT_STRING(d["total_event"])) \(Localization("Sự kiện")) | \(CONVERT_STRING(d["total_host"])) \(Localization("Địa điểm")) | \(CONVERT_STRING(d["total_article"])) \(Localization("Bài viết"))"
                return cell
            case .Users:
                let cell = self.tableView.dequeueReusableCellWithIdentifier("CellFollower", forIndexPath: indexPath) as! CellFollower
                LazyImage.showForImageView(cell.avatar, url: CONVERT_STRING(d["image"]))
                cell.name.text = CONVERT_STRING(d["name"])
                cell.address.text = CONVERT_STRING(d["location"])
                if CONVERT_BOOL(d["is_follow"]) {
                    cell.btnFollow.hidden = true
                    cell.btnFollowed.hidden = false
                } else {
                    cell.btnFollow.hidden = false
                    cell.btnFollowed.hidden = true
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
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !finishData && !isLoading && indexPath.row == data.count-1 {
            isLoading = true
            page += 1
            loadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch self.typeSearch {
        case .Tag:
            performSegueWithIdentifier("DetailTag", sender: nil)
            break
        case .Users:
//            performSegueWithIdentifier("DetailUser", sender: nil)
            break
        case .Event, .Host:
            performSegueWithIdentifier("DetailEvent", sender: nil)
        case .Article:
            performSegueWithIdentifier("DetailBlog", sender: nil)
        default:
            performSegueWithIdentifier("DetailTag", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let data:Dictionary<String,AnyObject> = self.data[(tableView.indexPathForSelectedRow?.row)!] {
            if segue.identifier == "DetailTag" {
                let next = segue.destinationViewController as! SearchTagController
                next.tagId = CONVERT_STRING(data["id"])
                next.tagName = CONVERT_STRING(data["name"])
            } else if segue.identifier == "DetailUser" {
                
            } else if segue.identifier == "DetailEvent" {
                let next = segue.destinationViewController as! DetailEventController
                next.data = data
                next.cate = typeSearch
            } else if segue.identifier == "DetailBlog" {
                let next = segue.destinationViewController as! DetailBlogController
                next.id = CONVERT_STRING(data["id"])
            }
        }
    }
}
