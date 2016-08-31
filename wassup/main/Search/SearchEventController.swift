//
//  SearchEventController.swift
//  wassup
//
//  Created by MAC on 8/24/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class SearchEventController: UITableViewController {

    var page = 1
    var data: [Dictionary<String, AnyObject>]?
    var isLoading = false
    var cate:ObjectType {
        return ObjectType.Event
    }
    var action = ""
    var districtId = ""
    var filterEvent:FilterEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "CellSearch", bundle: nil), forCellReuseIdentifier: "CellSearch")
        tableView.registerNib(UINib(nibName: "CellBlog", bundle: nil), forCellReuseIdentifier: "CellBlog")
        
        let inset = UIEdgeInsetsMake(TabPageOption().tabHeight, 0, 0, 0)
        tableView.contentInset = inset;
        
        
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(loadData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        
        loadData(nil)
        
        //init filter
        initFilter()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CLICK_FILTER", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clickFilter), name: "CLICK_FILTER", object: nil)
        
        //init select province
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SELECT_PROVINCE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectProvince), name: "SELECT_PROVINCE", object: nil)
    }
    
    func initFilter() {
        self.filterEvent = FilterEvent(frame: insideView!.frame)
        self.filterEvent?.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //refresh data after filter
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "REFRESH_DATA_WITH_FILTER", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshDataFilter(_:)), name: "REFRESH_DATA_WITH_FILTER", object: nil)
        
        //click filter
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CLICK_FILTER", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clickFilter), name: "CLICK_FILTER", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "REFRESH_DATA_WITH_FILTER", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CLICK_FILTER", object: nil)
    }
    
    func refreshDataFilter(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        action = "\(CONVERT_STRING(d["time"])),\(CONVERT_STRING(d["range"]))"
        districtId = CONVERT_STRING(d["district"])
        self.data = nil
        self.page = 1
        loadData(nil)
    }
    
    func clickFilter() {
        if self.filterEvent!.hidden {
            self.parentViewController?.view.addSubview(self.filterEvent!)
            filterEvent?.hidden = false
            filterEvent?.resetData()
        } else {
            self.filterEvent!.removeFromSuperview()
            filterEvent?.hidden = true
        }
    }
    
    func selectProvince(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        self.filterEvent?.cityId = CellDropdown(id: d["cityId"]!, value: d["cityName"]!)
    }
    
    func loadData(ref: UIRefreshControl?) {
        isLoading = true
        if ref != nil {
            self.data = nil
            page = 1
        }
        let md = Search()
        md.events(1, index: page, keyword: "", action: action, districtId: districtId) {
            (result:AnyObject?) in
            if result != nil {
                guard let d = result!["objects"] as? [Dictionary<String, AnyObject>] else {
                    self.data = nil
                    self.tableView.reloadData()
                    return
                }
                if self.data == nil {
                    self.data = d
                } else {
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
        return self.data == nil ? 0 : (self.data?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellSearch", forIndexPath: indexPath) as! CellSearch
        
        let data:Dictionary<String,AnyObject> = self.data![indexPath.row]
        cell.cate = self.cate
        cell.id = CONVERT_STRING(data["id"])
        cell.initCell(data)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("DetailEvent", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let next = segue.destinationViewController as! DetailEventController
        if let data:Dictionary<String,AnyObject> = self.data![(tableView.indexPathForSelectedRow?.row)!] {
            next.data = data
            next.cate = self.cate
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isLoading && indexPath.row == (data?.count)!-1 {
            page+=1
            loadData(nil)
        }
    }
}
