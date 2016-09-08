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
    var data:[Dictionary<String, AnyObject>]!
    var isLoading = false
    var cate:ObjectType {
        return ObjectType.Event
    }
    var action = ""
    var districtId = ""
    var city = ""
    var filterEvent:FilterEvent?
    var isFinish = false
    let ref = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [Dictionary<String,AnyObject>]()
        
        tableView.registerNib(UINib(nibName: "CellSearch", bundle: nil), forCellReuseIdentifier: "CellSearch")
        tableView.registerNib(UINib(nibName: "CellBlog", bundle: nil), forCellReuseIdentifier: "CellBlog")
        
        self.data = [Dictionary<String,AnyObject>]()
        
        self.initView()
        
        ref.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        //init filter
        initFilter()
        
        loadData()
        
    }
    
    func initView() {
        let inset = UIEdgeInsetsMake(TabPageOption().tabHeight, 0, 0, 0)
        tableView.contentInset = inset;
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
        
        //init select province
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SELECT_PROVINCE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectProvince), name: "SELECT_PROVINCE", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "REFRESH_DATA_WITH_FILTER", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "CLICK_FILTER", object: nil)
    }
    
    func refreshDataFilter(noti: NSNotification) {
        let d = noti.userInfo as! Dictionary<String, String>
        action = "\(CONVERT_STRING(d["time"])),9,\(CONVERT_STRING(d["range"]))"
        districtId = CONVERT_STRING(d["district"])
        city = CONVERT_STRING(d["city"])
        
        if d["district"] == "" {
            action = "\(CONVERT_STRING(d["time"])),12,\(CONVERT_STRING(d["range"]))"
        }
        
        self.data!.removeAll()
        self.tableView.reloadData()
        self.page = 1
        isFinish = false
        loadData()
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
        action = "12"
        city = d["cityName"]!
        resetData()
        loadData()
    }
    
    func resetData() {
        page = 1
        data.removeAll()
        isFinish = false
        tableView.reloadData()
    }
    
    func refreshData(ref: UIRefreshControl) {
        resetData()
        loadData()
    }
    
    func loadData() {
        if isFinish {
            return
        }
        isLoading = true
        let md = Search()
        md.events(0, index: page, keyword: "", action: action, districtId: districtId, city: city) {
            (result:AnyObject?) in
            if result != nil {
                guard let d = result!["objects"] as? [Dictionary<String, AnyObject>] else {                    return
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
        return self.data != nil ? self.data.count : 0
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
        if !isLoading && !isFinish && indexPath.row == data!.count-1 {
            page+=1
            loadData()
        }
    }
}
