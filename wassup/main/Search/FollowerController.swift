//
//  FollowController.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class FollowerController: UITableViewController {

    var eventId = ""
    var cate = ObjectType.Event
    var data:[Dictionary<String,AnyObject>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let inset = UIEdgeInsetsMake(40, 0, 0, 0)
        tableView.contentInset = inset;
        
        loadData(nil)
        
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(loadData(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(ref)
        
        tableView.registerNib(UINib(nibName: "CellFollower", bundle: nil), forCellReuseIdentifier: "CellFollower")
    }
    
    func loadData(ref: UIRefreshControl?) {
        if cate == ObjectType.Event {
            let md = Event()
            md.listAttend(eventId) {
                (result: AnyObject?) in
                if result != nil {
                    if let d = result!["users"] as? [Dictionary<String,AnyObject>] {
                        self.data = d
                        self.tableView.reloadData()
                    }
                }
                if ref != nil {
                    ref?.endRefreshing()
                }
            }
        } else {
            let md = Host()
            md.listFollows(eventId) {
                (result: AnyObject?) in
                if result != nil {
                    if let d = result!["users"] as? [Dictionary<String,AnyObject>] {
                        self.data = d
                        self.tableView.reloadData()
                    }
                }
                if ref != nil {
                    ref?.endRefreshing()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data == nil ? 0 : (self.data?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellFollower", forIndexPath: indexPath) as! CellFollower
        let d:Dictionary<String,AnyObject> = self.data![indexPath.row]

        LazyImage.showForImageView(cell.avatar, url: CONVERT_STRING(d["image"]))
        cell.name.text = CONVERT_STRING(d["fullname"])
        cell.address.text = CONVERT_STRING(d["address"])
        if CONVERT_BOOL(d["is_follow"]) {
            cell.btnFollow.hidden = true
            cell.btnFollowed.hidden = false
        } else {
            cell.btnFollow.hidden = false
            cell.btnFollowed.hidden = true
        }
        if User.sharedInstance.userId == CONVERT_STRING(d["user_id"]) {
            cell.btnFollow.hidden = true
            cell.btnFollowed.hidden = true
        }
        cell.userId = CONVERT_STRING(d["user_id"])
        return cell
    }
}
